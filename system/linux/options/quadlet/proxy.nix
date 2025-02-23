{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.virtualisation.quadlet.proxy;

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
        ${lib.optionalString (vhost.reverseProxy.upstreams != [ ]) ''
          reverse_proxy ${lib.concatStringsSep " " vhost.reverseProxy.upstreams} {
            ${vhost.reverseProxy.extraConfig}
          }
        ''}
        ${vhost.extraConfig}
      }
    '';

  mkDomainConfig =
    domain:
    let
      proxyNetwork = cfg.networks.internal.ref;

      proxyContainers = lib.filterAttrs (
        _: container:
        (lib.findSingle (
          network: lib.hasPrefix "${proxyNetwork}:" network
        ) null null container.containerConfig.Network) != null
      ) config.virtualisation.quadlet.containers;
    in
    ''
      *.${domain.name} {
        ${domain.extraConfig}

        ${lib.concatLines (
          map mkVirtualHost (
            lib.mapAttrsToList (_: value: {
              domain = domain.name;
              vhost = value.virtualHost;
            }) proxyContainers
          )
        )}

        ${lib.concatLines (
          map mkVirtualHost (
            lib.mapAttrsToList (_: value: {
              domain = domain.name;
              vhost = value;
            }) cfg.virtualHosts
          )
        )}

        handle {
          abort
        }
      }
    '';

  Caddyfile-raw = pkgs.writeTextDir "Caddyfile" ''
    {
      email ${cfg.email}
      ${lib.optionalString cfg.acmeStaging "acme_ca https://acme-staging-v02.api.letsencrypt.org/directory"}
      ${cfg.globalConfig}
    }

    (only_lan) {
      @wan not remote_ip private_ranges
      abort @wan
    }

    ${cfg.extraConfig}

    ${lib.concatLines (map mkDomainConfig (lib.attrValues cfg.domains))}
  '';

  Caddyfile-formatted =
    pkgs.runCommand "Caddyfile-formatted" { nativeBuildInputs = [ pkgs.caddy ]; }
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
  options.virtualisation.quadlet.proxy = with lib; {
    enable = mkEnableOption "Reverse proxy with Caddy";

    systemdConfig = mkOption {
      type = types.attrsOf types.anything;
      default = { };
    };

    networks = {
      internal = {
        ref = mkOption { type = with types; str; };
        ip = mkOption { type = with types; str; };
      };
      external = {
        ref = mkOption { type = with types; str; };
        ip = mkOption { type = with types; str; };
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

    virtualHosts = mkOption {
      default = { };
      type = types.attrsOf (types.submodule ./_vhost.nix);
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
  config = lib.mkIf (config.virtualisation.quadlet.enable && cfg.enable) {
    virtualisation.quadlet.containers.proxy = lib.mkMerge [
      {
        imageStream = pkgs.caddy-custom-docker;
        containerConfig = {
          Volume = [
            "${cfg.configFile}:/etc/caddy/Caddyfile:ro"
            "${cfg.storage.data}:/data"
            "${cfg.storage.config}:/config"
          ] ++ (lib.optional (cfg.storage.certificates != null) "${cfg.storage.certificates}:/certificates");
          Network = [
            "${cfg.networks.internal.ref}:ip=${cfg.networks.internal.ip}"
            "${cfg.networks.external.ref}:ip=${cfg.networks.external.ip}"
          ];
          PublishPort = [
            "80:80"
            "443:443"
            "443:443/udp"
          ];
        };
      }
      cfg.systemdConfig
    ];
  };
}
