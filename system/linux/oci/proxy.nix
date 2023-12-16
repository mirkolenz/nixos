{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.oci;
  proxyCfg = cfg.proxy;

  hostOptions = {
    options = with lib; {
      # unique to generic proxies
      reverseProxy = mkOption {
        type = with types; str;
      };

      # also used for container proxies
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
  };
  mkHostConf = attrs: ''
    ${lib.concatStringsSep " " attrs.names} {
      reverse_proxy ${attrs.reverseProxy}
      ${lib.optionalString attrs.lanOnly "import only_lan"}
      ${attrs.extraConfig}
    }
  '';

  mkContainerHostConf = container: let
    prefix = cfg.networks.${proxyCfg.network}.prefix;
    suffix = container.networks.${proxyCfg.network}.suffix;
  in
    mkHostConf (container.proxy
      // {
        reverseProxy = "${prefix}.${suffix}";
      });

  filteredContainers = builtins.attrValues (
    lib.filterAttrs
    (name: container: container.proxy != null)
    cfg.containers
  );

  boolToOnOff = b:
    if b
    then "on"
    else "off";

  Caddyfile = pkgs.writeTextDir "Caddyfile" ''
    {
      email ${proxyCfg.email}
      auto_https ${boolToOnOff proxyCfg.autoHttps}
      ${proxyCfg.globalConfig}
    }

    (only_lan) {
      @wan not remote_ip private_ranges
      abort @wan
    }

    # (add_basicauth) {
    # 	basicauth * {
    # 		admin {$CADDY_AUTH_ADMIN}
    # 	}
    # }

    ${proxyCfg.extraConfig}

    ${lib.concatLines (builtins.map mkContainerHostConf filteredContainers)}
    ${lib.concatLines (builtins.map mkHostConf proxyCfg.hosts)}
  '';
in {
  options.custom.oci.proxy = with lib; {
    enable = mkEnableOption "Reverse proxy with Caddy";

    network = mkOption {
      type = with types; str;
      default = "proxy";
    };

    networkSuffix = mkOption {
      type = with types; str;
      default = "2";
    };

    # https://hub.docker.com/_/caddy
    imageTag = mkOption {
      type = with types; str;
      default = "2";
    };

    dataDir = mkOption {
      type = with types; str;
    };

    configDir = mkOption {
      type = with types; str;
    };

    email = mkOption {
      type = with types; str;
    };

    autoHttps = mkOption {
      type = with types; bool;
      default = true;
    };

    hosts = mkOption {
      type = with types; listOf (submodule hostOptions);
      default = [];
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Additional lines of configuration appended to the automatically generated `Caddyfile`.
      '';
    };

    globalConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Additional lines of configuration appended to the automatically generated `Caddyfile`.
      '';
    };
  };
  config = lib.mkIf (cfg.enable && proxyCfg.enable) {
    custom.oci.containers.proxy = {
      inherit (cfg) enable;
      image = {
        name = "caddy";
        tag = proxyCfg.imageTag;
      };
      volumes = [
        ["${Caddyfile}/Caddyfile" "/etc/caddy/Caddyfile" "ro"]
        [(builtins.toString proxyCfg.dataDir) "/data"]
        [(builtins.toString proxyCfg.configDir) "/config"]
      ];
      networks = {
        ${proxyCfg.network} = {
          suffix = proxyCfg.networkSuffix;
        };
      };
      ports = [
        "80:80"
        "443:443"
        "443:443/udp"
      ];
    };
  };
}
