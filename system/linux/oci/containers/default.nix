{
  config,
  options,
  lib,
  ...
}: let
  cfg = config.custom.oci;
  containersCfg = cfg.containers;
  networksCfg = cfg.networks;

  getDefault = attr: options.custom.oci.containers.${attr}.default;

  mkLinks = let
    mkLink = container: link: let
      prefix = networksCfg.${link.network}.prefix;
      suffix = containersCfg.${container}.networks.${link.network}.suffix;
      ip = "${prefix}.${suffix}";
    in "${link.name}:${ip}";
  in
    attrs:
      cli.mkOptions {
        add-host = lib.mapAttrsToList mkLink attrs;
      };

  mkNetworks = let
    mkNetwork = name: value:
      lib.nameValuePair name {
        inherit (value) alias mac;
        ip = "${networksCfg.${name}.prefix}.${value.suffix}";
        interface_name = value.interface;
      };
  in
    attrs:
      assert (lib.assertMsg (builtins.length (builtins.attrNames attrs) > 0) "At least one network must be specified.");
        cli.mkOptions {
          network = lib.mapAttrsToList mkNetwork attrs;
        };

  cli = import ./cli.nix lib;

  mkContainer = name: container:
    lib.mkIf container.enable {
      inherit
        (container)
        imageFile
        cmd
        environmentFiles
        ports
        user
        workdir
        hostname
        autoStart
        ;

      image = cli.mkImage container.image;
      environment = (getDefault "environment") // container.environment;
      volumes = cli.mkVolumes container.volumes;
      dependsOn =
        container.dependsOn
        ++ (builtins.attrNames
          (
            lib.filterAttrs
            (name: value: value.required)
            container.links
          ));
      labels =
        container.labels
        // (
          lib.optionalAttrs
          (container.update != null)
          {"io.containers.autoupdate" = container.update;}
        );
      extraOptions =
        (cli.mkOptions {
          pull = container.pull;
          subuidname = container.subidname;
          subgidname = container.subidname;
        })
        ++ (mkNetworks container.networks)
        ++ (mkLinks container.links)
        ++ (cli.mkHosts container.hosts)
        ++ (cli.mkCaps ((getDefault "caps") // container.caps))
        ++ (cli.mkSysctl ((getDefault "sysctl") // container.sysctl))
        ++ (cli.mkOptions container.extraOptions)
        ++ container.extraArgs;
    };
in {
  options.custom.oci.containers = with lib;
    mkOption {
      default = {};
      type = with types; attrsOf (submodule (import ./submodule.nix));
    };
  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers =
      lib.mapAttrs (
        name: value: mkContainer name value
      )
      containersCfg;
    systemd.services =
      lib.mapAttrs' (name: value: {
        name = "podman-${name}";
        value = value.systemd;
      })
      containersCfg;
  };
}
