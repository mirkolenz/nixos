{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.custom.oci;
  network = import ./network.nix {
    inherit cfg lib pkgs;
  };
  container = import ./container.nix {
    inherit cfg lib pkgs;
  };
  proxy = import ./proxy.nix {
    inherit cfg lib pkgs;
  };

  mkNetworks = networks:
    lib.mapAttrs' (name: value: {
      name = "containers/networks/${name}.json";
      value = {
        source = network.generate name value;
      };
    })
    networks;

  mkContainers = containers:
    lib.mapAttrs (
      name: value: container.generate name value
    )
    containers;
in {
  options.custom.oci = with lib; {
    enable = mkEnableOption "Enable OCI containers";

    containers = mkOption {
      default = {};
      type = with types; attrsOf (submodule container.submodule);
    };

    networks = mkOption {
      default = {};
      type = with types; attrsOf (submodule network.submodule);
    };

    proxy = mkOption {
      type = with types; submodule proxy.submodule;
    };

    proxyContainer = mkOption {
      type = with types; submodule container.submodule;
      readOnly = true;
    };

    subidname = mkOption {
      type = with types; str;
    };

    update = mkOption {
      default = {};
      type = types.submodule {
        options = {
          enable = mkEnableOption "Automatic updates of container images";
          startAt = mkOption {
            type = types.str;
            description = "Systemd timer start time";
            # default = "*-*-* 02:00:00";
          };
        };
      };
    };
  };

  config = lib.mkIf (cfg.enable) {
    virtualisation.oci-containers = {
      backend = "podman";
      containers = mkContainers (
        cfg.containers
        // {
          proxy = cfg.proxyContainer;
        }
      );
    };
    environment.etc = mkNetworks cfg.networks;

    systemd.services.oci-update = lib.mkIf cfg.update.enable {
      inherit (cfg.update) startAt;
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      serviceConfig.Type = "oneshot";
      script = ''
        ${lib.getExe' pkgs.podman "podman"} auto-update
      '';
    };

    # https://hub.docker.com/_/caddy
    custom.oci.proxyContainer = {
      enable = cfg.proxy.enable;
      image = {
        name = "caddy";
        tag = cfg.proxy.imageTag;
      };
      volumes = [
        ["${proxy.Caddyfile}/Caddyfile" "/etc/caddy/Caddyfile" "ro"]
        [(builtins.toString cfg.proxy.dataDir) "/data"]
        [(builtins.toString cfg.proxy.configDir) "/config"]
      ];
      networkSuffixes = {
        ${cfg.proxy.network} = cfg.proxy.networkSuffix;
      };
      ports = [
        "80:80"
        "443:443"
        "443:443/udp"
      ];
    };
  };
}
