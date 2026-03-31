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
    maple-mono.truetype
    maple-mono.NF-unhinted
    teams-for-linux
  ];
  home.file.".face".source = ../mlenz.jpg;
}
