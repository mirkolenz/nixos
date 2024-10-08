{
  config,
  lib,
  lib',
  pkgs,
  ...
}:
let
  cfg = config.custom.oci;
  containersCfg = cfg.containers;
  networksCfg = cfg.networks;

  mkLinks = cli.mkLinks networksCfg containersCfg;
  mkNetworks = cli.mkNetworks networksCfg;

  mkExtraOptions =
    container:
    (cli.mkOptions { inherit (container) pull; })
    ++ (mkNetworks container.networks)
    ++ (mkLinks container.links)
    ++ (cli.mkUserns container.userns)
    ++ (cli.mkEnv container.environment)
    ++ (cli.mkHosts container.hosts)
    ++ (cli.mkCaps container.caps)
    ++ (cli.mkSysctls container.sysctls)
    ++ (cli.mkOptions container.extraOptions)
    ++ container.extraArgs;

  cli = import ./cli.nix { inherit lib lib'; };

  mkContainer =
    name: container:
    lib.mkIf container.enable {
      inherit (container)
        dependsOn
        imageFile
        # imageStream # TODO: 24.11
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
      labels = cli.mkLabels (
        container.labels
        // (lib.optionalAttrs (container.update != null) { io.containers.autoupdate = container.update; })
      );
      extraOptions = mkExtraOptions container;
    };

  mkWrapper =
    name: container:
    let
      image = cli.mkImage container.image;
      # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/oci-containers.nix
      defaultArgs = lib.escapeShellArgs (
        (cli.mkOptions {
          inherit name;
          inherit (container)
            workdir
            entrypoint
            hostname
            user
            ;
          rm = true;
          volume = cli.mkVolumes container.volumes;
          label = lib.attrsToList (cli.mkLabels container.labels);
          env-file = container.environmentFiles;
          publish = container.ports;
          replace = false;
        })
        ++ (mkExtraOptions container)
      );
      defaultCmd = lib.escapeShellArgs container.cmd;
    in
    pkgs.writeShellApplication {
      name = "oci-${name}";
      text = ''
        if ! [[ -v CMD ]]; then
          CMD=(${defaultCmd})
        fi
        if ! [[ -v ARGS ]]; then
          ARGS=()
        fi
        exec sudo ${lib.getExe pkgs.podman} run ${defaultArgs} "''${ARGS[@]}" ${image} "''${CMD[@]}"
      '';
    };

  mkSystemd =
    attrs:
    lib.recursiveUpdate {
      serviceConfig = {
        RestartSec = 15;
      };
      unitConfig = {
        # StartLimitIntervalSec must be greater than RestartSec * StartLimitBurst
        # otherwise the service will be restarted indefinitely.
        StartLimitIntervalSec = 120;
        StartLimitBurst = 6;
      };
    } attrs;
in
{
  options.custom.oci.containers =
    with lib;
    mkOption {
      default = { };
      type = with types; attrsOf (submodule (import ./submodule.nix cfg));
    };
  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = lib.mapAttrs (
      name: value: mkContainer name value
    ) containersCfg;
    systemd.services = lib.mapAttrs' (name: value: {
      name = "podman-${name}";
      value = mkSystemd value.systemd;
    }) containersCfg;
    environment.systemPackages = lib.mkIf cfg.shellWrapper.enable (
      lib.mapAttrsToList mkWrapper containersCfg
    );
  };
}
