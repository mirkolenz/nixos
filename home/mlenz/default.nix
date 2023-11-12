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
  nixvimInput =
    if lib.versionAtLeast lib.trivial.release "23.11"
    then inputs.nixvim-unstable
    else inputs.nixvim-linux-stable;
in {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    nixvimInput.homeManagerModules.nixvim
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
