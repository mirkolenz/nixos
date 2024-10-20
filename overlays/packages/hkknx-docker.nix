{
  lib,
  dockerTools,
  cacert,
  tzdata,
  hkknx-bin,
}:
let
  mkCliOptions = lib.cli.toGNUCommandLine rec {
    mkOptionName = k: "--${k}";
    mkBool = k: v: [
      (mkOptionName k)
      (lib.boolToString v)
    ];
  };
  defaultOptions = mkCliOptions {
    autoupdate = false;
    verbose = false;
    db = "/db";
    port = 80;
  };
in
dockerTools.buildLayeredImage {
  name = "hkknx";
  tag = "latest";
  created = "now";
  contents = [
    cacert
    tzdata
  ];
  # create /tmp for backup feature to work
  extraCommands = ''
    mkdir -m 1777 tmp
  '';
  config.entrypoint = [ (lib.getExe hkknx-bin) ] ++ defaultOptions;
}
