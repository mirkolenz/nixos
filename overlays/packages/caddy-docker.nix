# https://github.com/caddyserver/caddy-docker/blob/master/Dockerfile.tmpl
{
  lib,
  dockerTools,
  caddy,
  cacert,
  tzdata,
}:
(dockerTools.streamLayeredImage {
  name = "caddy";
  tag = "latest";
  created = "now";
  contents = [
    cacert
    tzdata
  ];
  extraCommands = ''
    mkdir -m 1777 tmp
  '';
  config = {
    Entrypoint = [ (lib.getExe caddy) ];
    Cmd = [
      "run"
      "--config"
      "/etc/caddy/Caddyfile"
      "--adapter"
      "caddyfile"
    ];
    ExposedPorts = {
      "80/tcp" = { };
      "443/tcp" = { };
      "443/udp" = { };
      "2019/tcp" = { };
    };
    # https://caddyserver.com/docs/conventions#file-locations
    Env = [
      "XDG_CONFIG_HOME=/config"
      "XDG_DATA_HOME=/data"
      "HOME=/root"
    ];
    WorkingDir = "/srv";
  };
}).overrideAttrs
  (finalAttrs: {
    meta = (finalAttrs.meta or { }) // {
      maintainers = with lib.maintainers; [ mirkolenz ];
      platforms = lib.platforms.linux;
    };
  })
