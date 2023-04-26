{ lib, config, osConfig, pkgs, extras, ... }:
let
  username = "mlenz";
  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  imports = [
    ./xserver.nix
    ./programs
    ./files
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    inherit username;
    inherit (extras) stateVersion;
    homeDirectory = lib.mkDefault homeDirectory;
    shellAliases = {
      dc = "docker compose";
      ls = "exa";
      ll = "exa -l";
      la = "exa -la";
      l = "exa -l";
      py = "poetry run python -m";
      hass = "hass-cli";
    };
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };
}
