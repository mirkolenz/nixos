{
  pkgs,
  extras,
  lib,
  osConfig,
  userLogin,
  inputs,
  ...
}: let
  homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${userLogin}"
    else "/home/${userLogin}";
in {
  imports = [
    ./xserver.nix
    ./programs
    ./files
    ./packages
  ];

  home = {
    inherit homeDirectory;
    inherit (extras) stateVersion;
    username = userLogin;
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };

  news.display = "show";

  nix = {
    package = lib.mkIf (osConfig == {}) pkgs.nix;
    registry = lib.mkIf (osConfig == {}) (import ../../registry.nix {
      inherit inputs pkgs;
    });
  };
}
