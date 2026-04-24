{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.custom.features.withDisplay {
  home.packages = with pkgs; [
    anydesk
    firefox
    # google-chrome # todo: not available on aarch64-linux
    obsidian
    teams-for-linux
    vivaldi
    zoom-us
    zotero
  ];
  home.file.".face".source = ../mlenz.jpg;
}
