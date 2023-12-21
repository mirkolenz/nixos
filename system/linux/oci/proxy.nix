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
    proxyNetwork = proxyCfg.networks.proxy.name;
    prefix = cfg.networks.${proxyNetwork}.prefix;
    suffix = container.networks.${proxyNetwork}.suffix;
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

    networks = {
      proxy = {
        name = mkOption {
          type = with types; str;
        };
        suffix = mkOption {
          type = with types; str;
        };
      };
      external = {
        name = mkOption {
          type = with types; str;
        };
        suffix = mkOption {
          type = with types; str;
        };
      };
    };

    # https://hub.docker.com/_/caddy
    image = {
      name = mkOption {
        type = with types; str;
        default = "caddy";
      };
      tag = mkOption {
        type = with types; str;
        default = "2";
      };
    };

    storage = {
      data = mkOption {
        type = with types; str;
      };

      config = mkOption {
        type = with types; str;
      };
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
      inherit (proxyCfg) enable image;
      volumes = [
        ["${Caddyfile}/Caddyfile" "/etc/caddy/Caddyfile" "ro"]
        [(builtins.toString proxyCfg.storage.data) "/data"]
        [(builtins.toString proxyCfg.storage.config) "/config"]
      ];
      networks = {
        ${proxyCfg.networks.proxy.name} = {
          suffix = proxyCfg.networks.proxy.suffix;
        };
        ${proxyCfg.networks.external.name} = {
          suffix = proxyCfg.networks.external.suffix;
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
