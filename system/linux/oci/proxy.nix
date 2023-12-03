{
  cfg,
  lib,
  pkgs,
}: let
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
    prefix = cfg.networks.${cfg.proxy.network}.prefix;
    suffix = container.networkSuffixes.${cfg.proxy.network};
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
      email ${cfg.proxy.email}
      auto_https ${boolToOnOff cfg.proxy.autoHttps}
      ${cfg.proxy.globalConfig}
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

    ${cfg.proxy.extraConfig}

    ${lib.concatLines (builtins.map mkContainerHostConf filteredContainers)}
    ${lib.concatLines (builtins.map mkHostConf cfg.proxy.hosts)}
  '';
in {
  inherit Caddyfile;
  submodule = {
    options = with lib; {
      enable = mkEnableOption "Reverse proxy with Caddy";

      network = mkOption {
        type = with types; str;
        default = "proxy";
      };

      networkSuffix = mkOption {
        type = with types; str;
        default = "2";
      };

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
  };
}
