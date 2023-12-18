{
  pkgs,
  lib,
  osConfig,
  inputs,
  user,
  stateVersion,
  unstableVersion,
  mylib,
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
  imports =
    [
      inputs.nix-index-database.hmModules.nix-index
      nixvimInput.homeManagerModules.nixvim
    ]
    ++ (mylib.getModules ./.);

  home = {
    inherit homeDirectory stateVersion;
    username = user.login;
    sessionPath = lib.optional (osConfig == {}) "/run/system-manager/sw/bin";
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      HOMEBREW_AUTOREMOVE = "1";
    };
  };

  nix = lib.mkIf (osConfig == {}) {
    package = pkgs.nix;
    registry = import ../../registry.nix {
      inherit inputs pkgs;
    };
  };
}
