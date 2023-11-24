{
  pkgs,
  lib,
  osConfig,
  inputs,
  user,
  stateVersion,
  unstableVersion,
  ...
}: let
  homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${user.login}"
    else "/home/${user.login}";
  nixvimInput =
    if lib.versionAtLeast lib.trivial.release unstableVersion
    then inputs.nixvim-unstable
    else inputs.nixvim-linux-stable;
in {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    nixvimInput.homeManagerModules.nixvim
    ./compat
    ./files
    ./packages
    ./programs
    ./xserver.nix
  ];

  home = {
    inherit homeDirectory stateVersion;
    username = user.login;
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      HOMEBREW_AUTOREMOVE = "1";
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
