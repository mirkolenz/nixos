{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.virtualisation.quadlet.proxy;

  allVhosts =
    let
      containerVhosts = lib.mapAttrsToList (_: c: c.virtualHost) config.virtualisation.quadlet.containers;
      extraVhosts = lib.attrValues cfg.virtualHosts;
      hasConfig = vhost: vhost.reverseProxy.upstreams != [ ] || vhost.extraConfig != "";
    in
    lib.filter hasConfig (containerVhosts ++ extraVhosts);

  dashboardVhosts = lib.filter (vhost: vhost.name != cfg.dashboard.name) allVhosts;

  mkServiceCard = vhost: /* html */ ''
    <article>
      <h3>
        <a href="https://${vhost.name}.${cfg.primaryDomain}">
          <i class="fa-${vhost.icon.style} fa-${vhost.icon.name}"></i>
          ${vhost.name}
        </a>
      </h3>
    </article>
  '';

  dashboardHtml = pkgs.writeText "index.html" /* html */ ''
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Services</title>
        <link rel="stylesheet" href="pico.min.css" />
        <link rel="stylesheet" href="font-awesome/fontawesome.min.css" />
        <link rel="stylesheet" href="font-awesome/solid.min.css" />
        <link rel="stylesheet" href="font-awesome/brands.min.css" />
        <style>
          .grid {
            grid-template-columns: repeat(3, 1fr);
          }
        </style>
      </head>
      <body>
        <main class="container">
          <h1>Services</h1>
          <div class="grid">
            ${lib.concatMapStrings mkServiceCard dashboardVhosts}
          </div>
        </main>
      </body>
    </html>
  '';

  dashboardFiles = pkgs.runCommandLocal "dashboard-files" { } /* bash */ ''
    mkdir -p $out $out/font-awesome

    cp ${pkgs.picocss}/share/css/pico.min.css $out/

    cp ${pkgs.font-awesome-web}/share/css/fontawesome.min.css $out/font-awesome/
    cp ${pkgs.font-awesome-web}/share/css/solid.min.css $out/font-awesome/
    cp ${pkgs.font-awesome-web}/share/css/brands.min.css $out/font-awesome/
    cp -r ${pkgs.font-awesome-web}/share/webfonts $out/font-awesome/

    cp ${dashboardHtml} $out/index.html
  '';

  mkVirtualHost =
    {
      domain,
      vhost,
    }:
    let
      allNames = [ vhost.name ] ++ vhost.extraNames;
      allHostNames = map (name: "${name}.${domain}") allNames;
    in
    /* caddyfile */ ''
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

  mkDomainConfig = domain: /* caddyfile */ ''
    *.${domain.name} {
      ${domain.extraConfig}

      ${lib.concatLines (
        map (
          vhost:
          mkVirtualHost {
            domain = domain.name;
            inherit vhost;
          }
        ) allVhosts
      )}

      handle {
        abort
      }
    }
  '';

  Caddyfile-raw = pkgs.writeTextDir "Caddyfile" /* caddyfile */ ''
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
      /* bash */ ''
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

    dashboard = {
      enable = lib.mkEnableOption "dashboard showing all services";
      name = lib.mkOption {
        type = lib.types.str;
        default = "dashboard";
        description = "Subdomain name for the dashboard.";
      };
    };

    primaryDomain = lib.mkOption {
      type = lib.types.str;
      description = "Primary domain used for the dashboard.";
    };

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
    assertions = [
      {
        assertion = cfg.domains ? ${cfg.primaryDomain};
        message = "virtualisation.quadlet.proxy.primaryDomain must be a key in virtualisation.quadlet.proxy.domains";
      }
    ];

    virtualisation.quadlet.proxy.virtualHosts.dashboard = lib.mkIf cfg.dashboard.enable {
      name = cfg.dashboard.name;
      extraConfig = /* caddyfile */ ''
        root * /srv/dashboard
        file_server
      '';
    };

    virtualisation.quadlet.containers.proxy = lib.mkMerge [
      {
        imageStream = pkgs.caddy-docker;
        containerConfig = {
          Volume = [
            "${cfg.configFile}:/etc/caddy/Caddyfile:ro"
            "${cfg.storage.data}:/data"
            "${cfg.storage.config}:/config"
          ]
          ++ (lib.optional (cfg.storage.certificates != null) "${cfg.storage.certificates}:/certificates")
          ++ (lib.optional cfg.dashboard.enable "${dashboardFiles}:/srv/dashboard:ro");
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
