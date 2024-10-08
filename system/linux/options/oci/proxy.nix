{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.custom.oci;
  proxyCfg = cfg.proxy;

  domainOptions =
    { name, ... }:
    {
      options = with lib; {
        name = mkOption {
          type = types.str;
          default = name;
        };
        extraConfig = mkOption { type = types.lines; };
      };
    };

  hostOptions =
    { name, ... }:
    {
      options = with lib; {
        # only defined here
        reverseProxy = mkOption { type = with types; str; };

        # defined in ./containers/submodule.nix
        name = mkOption {
          type = with types; str;
          default = name;
        };
        extraNames = mkOption {
          type = with types; listOf str;
          default = [ ];
        };
        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Additional lines of configuration appended to this virtual host in the
            automatically generated `Caddyfile`.
          '';
        };
      };
    };
  mkHostConf =
    {
      name,
      extraNames,
      reverseProxy,
      extraConfig,
      domain,
    }:
    let
      allNames = [ name ] ++ extraNames;
      allHostNames = map (name: "${name}.${domain}") allNames;
    in
    ''
      @${name} host ${lib.concatStringsSep " " allHostNames}
      handle @${name} {
        reverse_proxy ${reverseProxy}
        ${extraConfig}
      }
    '';

  mkContainerHostConf =
    container: domain:
    let
      proxyNetwork = proxyCfg.networks.proxy.name;
      prefix = cfg.networks.${proxyNetwork}.prefix;
      suffix = container.networks.${proxyNetwork}.suffix;
    in
    mkHostConf (
      container.proxy
      // {
        inherit domain;
        reverseProxy = "${prefix}.${suffix}";
      }
    );

  mkDomainConfig =
    { name, extraConfig }:
    let
      proxyContainers = lib.filterAttrs (_: val: val.networks ? proxy) cfg.containers;
      injectDomain = attrs: map (val: val // { domain = name; }) (lib.attrValues attrs);
    in
    ''
      *.${name} {
        ${extraConfig}

        ${lib.concatLines (map mkContainerHostConf (injectDomain proxyContainers))}

        ${lib.concatLines (map mkHostConf (injectDomain proxyCfg.hosts))}

        handle {
          abort
        }
      }
    '';

  Caddyfile = pkgs.writeTextDir "Caddyfile" ''
    {
      email ${proxyCfg.email}
      ${proxyCfg.globalConfig}
    }

    (only_lan) {
      @wan not remote_ip private_ranges
      abort @wan
    }

    ${proxyCfg.extraConfig}

    ${lib.concatLines (map mkDomainConfig (lib.attrValues proxyCfg.domains))}
  '';
in
{
  options.custom.oci.proxy = with lib; {
    enable = mkEnableOption "Reverse proxy with Caddy";

    networks = {
      proxy = {
        name = mkOption { type = with types; str; };
        suffix = mkOption { type = with types; str; };
      };
      external = {
        name = mkOption { type = with types; str; };
        suffix = mkOption { type = with types; str; };
      };
    };

    storage = {
      data = mkOption { type = with types; str; };
      config = mkOption { type = with types; str; };
    };

    email = mkOption { type = with types; str; };

    domains = mkOption {
      type = with types; attrsOf (submodule domainOptions);
      default = { };
    };

    hosts = mkOption {
      type = with types; attrsOf (submodule hostOptions);
      default = { };
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional lines of configuration appended to the automatically generated `Caddyfile`.
      '';
    };

    globalConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional lines of configuration appended to the automatically generated `Caddyfile`.
      '';
    };
  };
  config = lib.mkIf (cfg.enable && proxyCfg.enable) {
    custom.oci.containers.proxy = {
      inherit (proxyCfg) enable;

      image = {
        name = lib.mkDefault "caddy";
        registry = lib.mkDefault null;
        tag = lib.mkDefault "latest";
      };

      imageFile = lib.mkDefault pkgs.custom-caddy-docker;
      # imageStream = lib.mkDefault pkgs.custom-caddy-docker.passthru.stream; # TODO: 24.11

      volumes = [
        [
          "${Caddyfile}/Caddyfile"
          "/etc/caddy/Caddyfile"
          "ro"
        ]
        [
          proxyCfg.storage.data
          "/data"
        ]
        [
          proxyCfg.storage.config
          "/config"
        ]
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
