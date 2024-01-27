args@{
  pkgs,
  lib,
  lib',
  osConfig,
  inputs,
  user,
  stateVersion,
  channel,
  os,
  ...
}:
let
  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user.login}" else "/home/${user.login}";
  nixvim = lib'.self.systemInput {
    inherit inputs channel os;
    name = "nixvim";
  };
in
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    nixvim.homeManagerModules.nixvim
  ] ++ (lib'.flocken.getModules ./.);

  home = {
    inherit homeDirectory stateVersion;
    username = user.login;
    sessionPath = lib.optional (osConfig == { }) "/run/system-manager/sw/bin";
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      HOMEBREW_AUTOREMOVE = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  nix = lib.mkIf (osConfig == { }) {
    package = pkgs.nix;
    registry = import ../../registry.nix args;
  };
}
