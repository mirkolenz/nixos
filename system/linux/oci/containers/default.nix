{
  config,
  lib,
  ...
}: let
  cfg = config.custom.oci;
  containersCfg = cfg.containers;
  networksCfg = cfg.networks;

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
      volumes = cli.mkVolumes container.volumes;
      dependsOn =
        container.dependsOn
        ++ (
          builtins.attrNames
          (
            lib.filterAttrs
            (name: value: value.required)
            container.links
          )
        );
      labels = lib.flocken.getLeaves (
        container.labels
        // (
          lib.optionalAttrs
          (container.update != null)
          {io.containers.autoupdate = container.update;}
        )
      );
      extraOptions =
        (cli.mkOptions {
          inherit (container) pull;
        })
        ++ (mkNetworks container.networks)
        ++ (mkLinks container.links)
        ++ (cli.mkUserns container.userns)
        ++ (cli.mkEnv container.environment)
        ++ (cli.mkHosts container.hosts)
        ++ (cli.mkCaps container.caps)
        ++ (cli.mkSysctls container.sysctls)
        ++ (cli.mkOptions container.extraOptions)
        ++ container.extraArgs;
    };

  mkSystemd = attrs:
    lib.recursiveUpdate {
      serviceConfig = {
        RestartSec = 30;
      };
      unitConfig = {
        # StartLimitIntervalSec must be greater than RestartSec * StartLimitBurst
        # otherwise the service will be restarted indefinitely.
        StartLimitIntervalSec = 120;
        StartLimitBurst = 3;
      };
    }
    attrs;
in {
  options.custom.oci.containers = with lib;
    mkOption {
      default = {};
      type = with types; attrsOf (submodule (import ./submodule.nix cfg));
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
        value = mkSystemd value.systemd;
      })
      containersCfg;
  };
}
