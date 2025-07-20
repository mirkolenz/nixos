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

  mkDomainConfig = domain: ''
    *.${domain.name} {
      ${domain.extraConfig}

      ${lib.concatLines (
        map mkVirtualHost (
          lib.mapAttrsToList (_: value: {
            domain = domain.name;
            vhost = value.virtualHost;
          }) config.virtualisation.quadlet.containers
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
  options.virtualisation.quadlet.proxy = {
    enable = lib.mkEnableOption "Reverse proxy with Caddy";

    systemdConfig = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
    };

    networks = {
      internal = {
        ref = lib.mkOption { type = with lib.types; str; };
        ip = lib.mkOption { type = with lib.types; str; };
      };
      external = {
        ref = lib.mkOption { type = with lib.types; str; };
        ip = lib.mkOption { type = with lib.types; str; };
      };
    };

    storage = {
      data = lib.mkOption { type = with lib.types; str; };
      config = lib.mkOption { type = with lib.types; str; };
      certificates = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
      };
    };

    email = lib.mkOption { type = with lib.types; str; };

    acmeStaging = lib.mkEnableOption "use Let's Encrypt staging server";

    domains = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                default = name;
              };
              extraConfig = lib.mkOption {
                type = lib.types.lines;
                default = "";
              };
            };
          }
        )
      );
    };

    virtualHosts = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule ./_vhost.nix);
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Additional lines of configuration appended to the automatically generated `Caddyfile`.
      '';
    };

    globalConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Additional lines of global configuration appended to the automatically generated `Caddyfile`.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = "${Caddyfile}/Caddyfile";
    };
  };
  config = lib.mkIf (config.virtualisation.quadlet.enable && cfg.enable) {
    virtualisation.quadlet.containers.proxy = lib.mkMerge [
      {
        imageStream = pkgs.caddy-docker;
        containerConfig = {
          Volume = [
            "${cfg.configFile}:/etc/caddy/Caddyfile:ro"
            "${cfg.storage.data}:/data"
            "${cfg.storage.config}:/config"
          ]
          ++ (lib.optional (cfg.storage.certificates != null) "${cfg.storage.certificates}:/certificates");
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
