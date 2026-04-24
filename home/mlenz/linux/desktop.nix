{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.custom.features.withDisplay {
  home.packages =
    with pkgs;
    [
      anydesk
      firefox
      obsidian
      teams-for-linux
      vivaldi
      zotero
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.isx86_64) [
      google-chrome
      zoom-us
    ];
  home.file.".face".source = ../mlenz.jpg;
}
