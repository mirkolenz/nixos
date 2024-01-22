{
  pkgs,
  lib,
  lib',
  osConfig,
  inputs,
  user,
  stateVersion,
  ...
}: let
  homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${user.login}"
    else "/home/${user.login}";
  nixvimInput =
    if (lib'.self.isUnstable lib)
    then inputs.nixvim-unstable
    else inputs.nixvim-linux-stable;
in {
  imports =
    [
      inputs.nix-index-database.hmModules.nix-index
      nixvimInput.homeManagerModules.nixvim
    ]
    ++ (lib'.flocken.getModules ./.);

  home = {
    inherit homeDirectory stateVersion;
    username = user.login;
    sessionPath = lib.optional (osConfig == {}) "/run/system-manager/sw/bin";
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      HOMEBREW_AUTOREMOVE = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  nix = lib.mkIf (osConfig == {}) {
    package = pkgs.nix;
    registry = import ../../registry.nix {
      inherit inputs pkgs;
    };
  };
}
