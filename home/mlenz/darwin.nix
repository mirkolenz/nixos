{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    mas
  ];
  programs.texliveCustom = {
    enable = true;
    bibFolder = "${config.home.homeDirectory}/Developer/mirkolenz/bibliography";
  };
}
