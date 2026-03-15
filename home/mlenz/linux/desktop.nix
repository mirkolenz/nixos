{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.custom.features.withDisplay {
  home.packages = with pkgs; [
    anydesk
    vivaldi
    firefox
    obsidian
    zoom-us
    zotero
    inter
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];
  home.file.".face".source = ../mlenz.jpg;
}
