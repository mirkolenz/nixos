{
  cfg,
  lib,
  pkgs,
}: let
  mkNestedCliOption = attrs: lib.concatStringsSep ":" (lib.mapAttrsToList (name: value: "${name}=${builtins.toString value}") attrs);
  mkCliOption = value:
    if builtins.isAttrs value
    then mkNestedCliOption value
    else builtins.toString value;
  mkCliOptions = attrs: lib.mapAttrsToList (name: value: "--${name}=${mkCliOption value}") attrs;

  mkAttrsCliOption = name: value:
    if value != {} && value != null && value != ""
    then "${name}:${mkCliOption value}"
    else name;
  mkAttrsCliOptions = namespace: attrs: lib.mapAttrsToList (name: value: "--${namespace}=${mkAttrsCliOption name value}") attrs;
  mkListCliOptions = namespace: values: builtins.map (value: "--${namespace}=${mkCliOption value}") values;

  mkNetwork = name: value: let
    params =
      if value != null && value != ""
      then null
      else {
        ip = "${cfg.networks.${name}.prefix}.${value}";
      };
  in
    mkAttrsCliOption name params;
  mkNetworks = attrs: lib.mapAttrsToList (name: value: "--network=${mkNetwork name value}") attrs;

  mkHost = name: value: "${name}:${value}";
  mkHosts = attrs: lib.mapAttrsToList (name: value: "--add-host=${mkHost name value}") attrs;

  mkLink = container: link: let
    prefix = cfg.networks.${link.network}.prefix;
    suffix = cfg.containers.${container}.networkSuffixes.${link.network};
    ip = "${prefix}.${suffix}";
  in "${link.name}:${ip}";
  mkLinks = attrs: lib.mapAttrsToList (name: value: "--add-host=${mkLink name value}") attrs;

  mkAttrVolume = {
    source,
    target,
    mode ? null,
  }:
    if mode == null
    then "${source}:${target}"
    else "${source}:${target}:${mode}";
  mkListVolume = values: lib.concatStringsSep ":" values;
  mkVolume = value:
    if builtins.isAttrs value
    then mkAttrVolume value
    else if builtins.isList value
    then mkListVolume value
    else builtins.toString value;
  mkVolumes = values: builtins.map mkVolume values;

  mkAttrsImage = {
    name,
    tag ? null,
  }:
    if tag == null
    then name
    else "${name}:${tag}";
  mkListImage = values: lib.concatStringsSep ":" values;
  mkImage = value:
    if builtins.isAttrs value
    then mkAttrsImage value
    else if builtins.isList value
    then mkListImage value
    else builtins.toString value;

  generate = name: container: {
    inherit (container) imageFile cmd labels environmentFiles ports user workdir hostname autoStart;
    image = mkImage container.image;
    environment =
      {
        TZ = "Europe/Berlin";
      }
      // container.environment;
    volumes = mkVolumes container.volumes;
    dependsOn =
      container.dependsOn
      ++ (builtins.attrNames
        (
          lib.filterAttrs
          (name: value: value.required)
          container.links
        ));
    extraOptions =
      (mkCliOptions {
        pull = container.pull;
        subuidname = container.subidname;
        subgidname = container.subidname;
      })
      ++ (mkNetworks container.networkSuffixes)
      ++ (mkHosts container.hosts)
      ++ (mkLinks container.links)
      ++ container.runArgs;
  };
in {
  inherit generate;
  submodule = {
    options = with lib; {
      image = mkOption {
        type = with types; attrsOf str;
      };

      imageFile = mkOption {
        type = with types; nullOr package;
        default = null;
        description = lib.mdDoc ''
          Path to an image file to load before running the image. This can
          be used to bypass pulling the image from the registry.

          The `image` attribute must match the name and
          tag of the image contained in this file, as they will be used to
          run the container with that image. If they do not match, the
          image will be pulled from the registry as usual.
        '';
        example = literalExpression "pkgs.dockerTools.buildImage {...};";
      };

      pull = mkOption {
        type = with types; str;
        default = "newer";
      };

      subidname = mkOption {
        type = with types; str;
        default = cfg.subidname;
      };

      cmd = mkOption {
        type = with types; listOf str;
        default = [];
        description = lib.mdDoc "Commandline arguments to pass to the image's entrypoint.";
        example = literalExpression ''
          ["--port=9000"]
        '';
      };

      labels = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = lib.mdDoc "Labels to attach to the container at runtime.";
        example = literalExpression ''
          {
            "traefik.https.routers.example.rule" = "Host(`example.container`)";
          }
        '';
      };

      entrypoint = mkOption {
        type = with types; nullOr str;
        description = lib.mdDoc "Override the default entrypoint of the image.";
        default = null;
        example = "/bin/my-app";
      };

      environment = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = lib.mdDoc "Environment variables to set for this container.";
        example = literalExpression ''
          {
            DATABASE_HOST = "db.example.com";
            DATABASE_PORT = "3306";
          }
        '';
      };

      environmentFiles = mkOption {
        type = with types; listOf path;
        default = [];
        description = lib.mdDoc "Environment files for this container.";
        example = literalExpression ''
          [
            /path/to/.env
            /path/to/.env.secret
          ]
        '';
      };

      ports = mkOption {
        type = with types; listOf str;
        default = [];
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          Override the username or UID (and optionally groupname or GID) used
          in the container.
        '';
        example = "nobody:nogroup";
      };

      volumes = mkOption {
        type = with types; listOf (listOf str);
        default = [];
        description = lib.mdDoc ''
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
        description = lib.mdDoc "Override the default working directory for the container.";
        example = "/var/lib/hello_world";
      };

      dependsOn = mkOption {
        type = with types; listOf str;
        default = [];
        description = lib.mdDoc ''
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
        description = lib.mdDoc "The hostname of the container.";
        example = "hello-world";
      };

      runArgs = mkOption {
        type = with types; listOf str;
        default = [];
        description = lib.mdDoc "Extra options for {command}`${defaultBackend} run`.";
        example = literalExpression ''
          ["--network=host"]
        '';
      };

      networkSuffixes = mkOption {
        type = with types; attrsOf str;
        default = {};
      };

      links = mkOption {
        default = {};
        type = types.attrsOf (types.submodule ({name, ...}: {
          options = {
            name = mkOption {
              type = with types; str;
              description = lib.mdDoc "The name of the link inside the container.";
              default = name;
            };

            network = mkOption {
              type = with types; str;
              description = lib.mdDoc "The network to link to.";
            };

            required = mkOption {
              type = with types; bool;
              default = false;
              description = lib.mdDoc "Whether this link is required.";
            };
          };
        }));
      };

      hosts = mkOption {
        type = with types; attrsOf str;
        default = {};
      };

      autoStart = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          When enabled, the container is automatically started on boot.
          If this option is set to false, the container has to be started on-demand via its service.
        '';
      };

      proxy = mkOption {
        default = null;
        type = types.nullOr (types.submodule {
          options = with lib; {
            names = mkOption {
              type = with types; listOf str;
            };

            lanOnly = mkOption {
              type = with types; bool;
              default = true;
              description = "Only allow access from the local network";
            };

            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = lib.mdDoc ''
                Additional lines of configuration appended to this virtual host in the
                automatically generated `Caddyfile`.
              '';
            };
          };
        });
      };
    };
  };
}
