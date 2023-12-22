{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.oci;
  containersCfg = cfg.containers;
  networksCfg = cfg.networks;

  mkLinks = cli.mkLinks networksCfg containersCfg;
  mkNetworks = cli.mkNetworks networksCfg;

  mkExtraOptions = container:
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

  cli = import ./cli.nix lib;

  mkContainer = name: container:
    lib.mkIf container.enable {
      inherit
        (container)
        imageFile
        cmd
        entrypoint
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
      labels = cli.mkLabels (
        container.labels
        // (
          lib.optionalAttrs
          (container.update != null)
          {io.containers.autoupdate = container.update;}
        )
      );
      extraOptions = mkExtraOptions container;
    };

  mkWrapper = name: container: let
    image = cli.mkImage container.image;
    args = lib.escapeShellArgs (
      (cli.mkOptions {
        inherit name;
        inherit (container) workdir entrypoint hostname user;
        rm = true;
        volume = cli.mkVolumes container.volumes;
        label = lib.attrsToList (cli.mkLabels container.labels);
        env-file = container.environmentFiles;
        publish = container.ports;
        replace = false;
        # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/oci-containers.nix
        # these seem to be systemd-specific
        # cidfile = "/run/podman-${name}.ctr-id";
        # log-driver = "journald";
        # cgroups = "no-conmon";
        # sdnotify = "conmon";
      })
      ++ (mkExtraOptions container)
    );
    cmd = lib.escapeShellArgs container.cmd;
  in
    pkgs.writeShellApplication {
      name = "oci-${name}";
      text = ''
        exec sudo ${lib.getExe' pkgs.podman "podman"} run ${args} "$@" ${image} ${cmd}
      '';
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
    environment.systemPackages = lib.mapAttrsToList mkWrapper containersCfg;
  };
}
