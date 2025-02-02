cfg:
{
  name,
  lib,
  config,
  ...
}:
{
  options = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the containers.";
    };

    name = mkOption {
      type = types.str;
      default = name;
    };

    systemd = mkOption {
      type = with types; attrsOf anything;
      default = { };
    };

    image = mkOption {
      type = types.either types.str (
        types.submodule {
          options = {
            name = mkOption {
              type = with types; str;
              description = "The name of the image to use.";
              example = "hello-world";
            };

            registry = mkOption {
              type = with types; nullOr str;
              description = "The registry to pull the image from.";
              example = "docker.io";
            };

            tag = mkOption {
              type = with types; str;
              description = "The tag of the image to use.";
              example = "latest";
            };
          };
        }
      );
    };

    imageFile = mkOption {
      type = with types; nullOr package;
      default = null;
      description = ''
        Path to an image file to load before running the image. This can
        be used to bypass pulling the image from the registry.

        The `image` attribute must match the name and
        tag of the image contained in this file, as they will be used to
        run the container with that image. If they do not match, the
        image will be pulled from the registry as usual.
      '';
      example = literalExpression "pkgs.dockerTools.buildImage {...};";
    };

    imageStream = mkOption {
      type = with types; nullOr package;
      default = null;
      description = ''
        Path to a script that streams the desired image on standard output.

        This option is mainly intended for use with
        `pkgs.dockerTools.streamLayeredImage` so that the intermediate
        image archive does not need to be stored in the Nix store.  For
        larger images this optimization can significantly reduce Nix store
        churn compared to using the `imageFile` option, because you don't
        have to store a new copy of the image archive in the Nix store
        every time you change the image.  Instead, if you stream the image
        then you only need to build and store the layers that differ from
        the previous image.
      '';
      example = literalExpression "pkgs.dockerTools.streamLayeredImage {...};";
    };

    pull = mkOption {
      type = with types; str;
      default = "missing";
      description = ''
        Pull image policy. The default is missing.

        - always: Always pull the image and throw an error if the pull fails.
        - missing: Pull the image only when the image is not in the local containers storage. Throw an error if no image is found and the pull fails.
        - never: Never pull the image but use the one from the local containers storage. Throw an error if no image is found.
        - newer: Pull if the image on the registry is newer than the one in the local containers storage. An image is considered to be newer when the digests are different. Comparing the time stamps is prone to errors. Pull errors are suppressed if a local image was found.
      '';
    };

    userns = mkOption {
      type = with types; str;
      default = cfg.userns;
    };

    cmd = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "Commandline arguments to pass to the image's entrypoint.";
      example = literalExpression ''
        ["--port=9000"]
      '';
    };

    labels = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = "Labels to attach to the container at runtime.";
      example = literalExpression ''
        {
          "traefik.https.routers.example.rule" = "Host(`example.container`)";
        }
      '';
    };

    update = mkOption {
      type = with types; nullOr str;
      default = if config.imageFile != null || config.imageStream != null then "local" else "registry";
      description = "If not null, add the label `io.containers.autoupdate=VALUE` to the container.";
    };

    entrypoint = mkOption {
      type = with types; nullOr str;
      description = "Override the default entrypoint of the image.";
      default = null;
      example = "/bin/my-app";
    };

    environment = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = "Environment variables to set for this container.";
      example = literalExpression ''
        {
          DATABASE_HOST = "db.example.com";
          DATABASE_PORT = "3306";
        }
      '';
    };

    environmentFiles = mkOption {
      type = with types; listOf path;
      default = [ ];
      description = "Environment files for this container.";
      example = literalExpression ''
        [
          /path/to/.env
          /path/to/.env.secret
        ]
      '';
    };

    ports = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        Network ports to publish from the container to the outer host.

        Valid formats:
        - `<ip>:<hostPort>:<containerPort>`
        - `<ip>::<containerPort>`
        - `<hostPort>:<containerPort>`
        - `<containerPort>`

        Both `hostPort` and `containerPort` can be specified as a range of
        ports.  When specifying ranges for both, the number of container
        ports in the range must match the number of host ports in the
        range.  Example: `1234-1236:1234-1236/tcp`

        When specifying a range for `hostPort` only, the `containerPort`
        must *not* be a range.  In this case, the container port is published
        somewhere within the specified `hostPort` range.
        Example: `1234-1236:1234/tcp`

        Refer to the
        [Docker engine documentation](https://docs.docker.com/engine/reference/run/#expose-incoming-ports) for full details.
      '';
      example = literalExpression ''
        [
          "8080:9000"
        ]
      '';
    };

    user = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Override the username or UID (and optionally groupname or GID) used
        in the container.
      '';
      example = "nobody:nogroup";
    };

    volumes = mkOption {
      type = with types; listOf (listOf str);
      default = [ ];
      description = ''
        List of volumes to attach to this container.

        Note that this is a list of `"src:dst"` strings to
        allow for `src` to refer to `/nix/store` paths, which
        would be difficult with an attribute set.  There are
        also a variety of mount options available as a third
        field; please refer to the
        [docker engine documentation](https://docs.docker.com/engine/reference/run/#volume-shared-filesystems) for details.
      '';
      example = literalExpression ''
        [
          "volume_name:/path/inside/container"
          "/path/on/host:/path/inside/container"
        ]
      '';
    };

    workdir = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "Override the default working directory for the container.";
      example = "/var/lib/hello_world";
    };

    dependsOn = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        Define which other containers this one depends on. They will be added to both After and Requires for the unit.

        Use the same name as the attribute under `virtualisation.oci-containers.containers`.
      '';
      example = literalExpression ''
        virtualisation.oci-containers.containers = {
          node1 = {};
          node2 = {
            dependsOn = [ "node1" ];
          }
        }
      '';
    };

    hostname = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "The hostname of the container.";
      example = "hello-world";
    };

    caps = mkOption {
      type = with types; attrsOf bool;
      default = { };
      description = "Linux system capabilities to set for this container.";
    };

    sysctls = mkOption {
      type = with types; attrsOf (either str (attrsOf anything));
      default = { };
      description = "Configure namespaced kernel parameters at runtime.";
    };

    extraArgs = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "Extra flags for {command}`${defaultBackend} run`.";
      example = literalExpression ''
        ["--network=host"]
      '';
    };

    extraOptions = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          str
          bool
          (attrsOf str)
          (listOf (onOf [
            str
            bool
            (attrsOf str)
            (listOf str)
          ]))
        ]);
      default = { };
      description = "Extra options for {command}`${defaultBackend} run`.";
      example = literalExpression ''
        {
          "network" = "host";
        }
      '';
    };

    networks = mkOption {
      default = { };
      type = types.attrsOf (
        types.nullOr (
          types.submodule {
            options = {
              suffix = mkOption {
                type = with types; str;
                description = "The suffix of the IP address in the specified network.";
              };

              alias = mkOption {
                type = with types; nullOr str;
                default = null;
              };

              mac = mkOption {
                type = with types; nullOr str;
                default = null;
              };

              interface = mkOption {
                type = with types; nullOr str;
                default = null;
              };
            };
          }
        )
      );
    };

    links = mkOption {
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              name = mkOption {
                type = with types; str;
                description = "The name of the link inside the container.";
                default = name;
              };

              network = mkOption {
                type = with types; str;
                description = "The network to link to.";
              };
            };
          }
        )
      );
    };

    hosts = mkOption {
      type = with types; attrsOf str;
      default = { };
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = ''
        When enabled, the container is automatically started on boot.
        If this option is set to false, the container has to be started on-demand via its service.
      '';
    };

    proxyVirtualHost =
      let
        network = cfg.proxy.networks.proxy.name;
        prefix = cfg.networks.${network}.prefix;
        suffix = config.networks.${network}.suffix or null;
      in
      mkOption {
        default = { };
        type = types.submodule (
          import ../proxy/vhost.nix {
            inherit name lib;
            defaultUpstreams = if suffix == null then [ ] else [ "${prefix}.${suffix}" ];
          }
        );
      };
  };
}
