{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    mas
    neovide-bin
    vimr-bin
    restic-browser-bin
  ];
  custom.texlive = {
    enable = true;
    bibFolder = "${config.home.homeDirectory}/Developer/mirkolenz/bibliography";
  };
  home.sessionVariables = {
    EDITOR = lib.mkForce "code -w";
  };
}
