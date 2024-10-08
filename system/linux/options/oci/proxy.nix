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
        extraConfig = mkOption {
          type = types.lines;
          default = "";
        };
      };
    };

  hostOptions =
    { name, ... }:
    {
      options = with lib; {
        # only defined here
        reverseProxy = mkOption { type = with types; str; };

        reverseProxyConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Additional lines of configuration appended to the reverse proxy in the
            automatically generated `Caddyfile`.
          '';
        };

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
      domain,
      value,
    }:
    let
      allNames = [ value.name ] ++ value.extraNames;
      allHostNames = map (name: "${name}.${domain}") allNames;
    in
    ''
      @${value.name} host ${lib.concatStringsSep " " allHostNames}
      handle @${value.name} {
        reverse_proxy ${value.reverseProxy} ${
          lib.optionalString (
            value.reverseProxyConfig != ""
          ) "{
          ${value.reverseProxyConfig}
        }"
        }
        ${value.extraConfig}
      }
    '';

  mkContainerHostConf =
    { domain, value }:
    let
      proxyNetwork = proxyCfg.networks.proxy.name;
      prefix = cfg.networks.${proxyNetwork}.prefix;
      suffix = value.networks.${proxyNetwork}.suffix;
    in
    mkHostConf {
      inherit domain;
      value = value.proxy // {
        reverseProxy = "${prefix}.${suffix}";
        reverseProxyConfig = "";
      };
    };

  mkDomainConfig =
    { name, extraConfig }:
    let
      proxyContainers = lib.filterAttrs (_: value: value.networks ? proxy) cfg.containers;
      injectDomain =
        attrs:
        map (value: {
          inherit value;
          domain = name;
        }) (lib.attrValues attrs);
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

  Caddyfile-raw = pkgs.writeTextDir "Caddyfile" ''
    {
      email ${proxyCfg.email}
      ${lib.optionalString proxyCfg.acmeStaging "acme_ca https://acme-staging-v02.api.letsencrypt.org/directory"}
      ${proxyCfg.globalConfig}
    }

    (only_lan) {
      @wan not remote_ip private_ranges
      abort @wan
    }

    ${proxyCfg.extraConfig}

    ${lib.concatLines (map mkDomainConfig (lib.attrValues proxyCfg.domains))}
  '';

  Caddyfile-formatted =
    pkgs.runCommand "Caddyfile-formatted" { nativeBuildInputs = [ pkgs.custom-caddy ]; }
      ''
        mkdir -p $out
        cp --no-preserve=mode ${Caddyfile-raw}/Caddyfile $out/Caddyfile
        caddy fmt --overwrite $out/Caddyfile
      '';

  Caddyfile =
    if pkgs.stdenv.buildPlatform == pkgs.stdenv.hostPlatform then
      Caddyfile-formatted
    else
      Caddyfile-raw;
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

    acmeStaging = mkEnableOption "use Let's Encrypt staging server";

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

    configFile = mkOption {
      type = types.path;
      default = "${Caddyfile}/Caddyfile";
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

      # required due to our custom image file
      update = lib.mkDefault "local";

      volumes = [
        [
          proxyCfg.configFile
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
      # https://caddyserver.com/docs/conventions#file-locations
      # https://github.com/caddyserver/caddy-docker/blob/master/Dockerfile.tmpl
      # TODO: could also be set in the custom caddy image
      environment = {
        XDG_CONFIG_HOME = "/config";
        XDG_DATA_HOME = "/data";
      };
    };
  };
}
