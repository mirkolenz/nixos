{ lib, config, osConfig, pkgs, extras, ... }:
let
  username = "mlenz";
  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
  exaArgs = "--long --icons --group-directories-first --git --color=always --time-style=long-iso";
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
      cat = "bat";
      ls = "exa";
      ll = "exa ${exaArgs}";
      la = "exa --all ${exaArgs}";
      l = "exa ${exaArgs}";
      top = "btm";
      dc = "sudo docker compose";
      py = "poetry run python -m";
      hass = "hass-cli";
      nixos-env = "sudo nix-env --profile /nix/var/nix/profiles/system";
    };
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };
}
