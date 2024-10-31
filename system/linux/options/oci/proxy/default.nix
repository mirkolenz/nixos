{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.custom.oci;
  proxyCfg = cfg.proxy;

  mkVirtualHost =
    {
      domain,
      vhost,
    }:
    let
      allNames = [ vhost.name ] ++ vhost.extraNames;
      allHostNames = map (name: "${name}.${domain}") allNames;
    in
    ''
      @${vhost.name} host ${lib.concatStringsSep " " allHostNames}
      handle @${vhost.name} {
        ${
          lib.optionalString (vhost.reverseProxy.upstreams != [ ]) ''
            reverse_proxy ${lib.concatStringsSep " " vhost.reverseProxy.upstreams} {
              ${vhost.reverseProxy.extraConfig}
            }
          ''
        }
        ${vhost.extraConfig}
      }
    '';

  mkDomainConfig =
    { name, extraConfig }:
    let
      proxyNetwork = proxyCfg.networks.proxy.name;
      proxyContainers = lib.filterAttrs (
        _: container: (container.networks ? ${proxyNetwork}) && (container.networks.${proxyNetwork} != null)
      ) cfg.containers;
      parseVirtualHosts =
        attrs:
        map (value: {
          vhost = value.proxyVirtualHost or value;
          domain = name;
        }) (lib.attrValues attrs);
    in
    ''
      *.${name} {
        ${extraConfig}

        ${lib.concatLines (map mkVirtualHost (parseVirtualHosts proxyContainers))}

        ${lib.concatLines (map mkVirtualHost (parseVirtualHosts proxyCfg.virtualHosts))}

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
      certificates = mkOption {
        type = with types; nullOr str;
        default = null;
      };
    };

    email = mkOption { type = with types; str; };

    acmeStaging = mkEnableOption "use Let's Encrypt staging server";

    domains = mkOption {
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              name = mkOption {
                type = types.str;
                default = name;
              };
              extraConfig = mkOption {
                type = types.lines;
                default = "";
              };
            };
          }
        )
      );
    };

    # change in ./containers/submodule.nix as well
    virtualHosts = mkOption {
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          import ./vhost.nix {
            inherit name lib;
            defaultUpstreams = [ ];
          }
        )
      );
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
        Additional lines of global configuration appended to the automatically generated `Caddyfile`.
      '';
    };

    configFile = mkOption {
      type = types.path;
      default = "${Caddyfile}/Caddyfile";
    };
  };
  config = lib.mkIf (cfg.enable && proxyCfg.enable) {
    custom.oci.containers.proxy = rec {
      inherit (proxyCfg) enable;

      image = {
        name = imageFile.imageName;
        tag = imageFile.imageTag;
        registry = null;
      };

      imageFile = lib.mkDefault pkgs.custom-caddy-docker;
      # imageStream = lib.mkDefault pkgs.custom-caddy-docker.passthru.stream; # TODO: 24.11

      volumes =
        [
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
        ]
        ++ (lib.optional (proxyCfg.storage.certificates != null) [
          proxyCfg.storage.certificates
          "/certificates"
        ]);
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
