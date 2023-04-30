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
      py = "poetry run python";
      hass = "hass-cli";
      nixos-env = "sudo nix-env --profile /nix/var/nix/profiles/system";
      poetryup = "/run/current-system/sw/bin/poetry up";
    };
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
    packages = with pkgs; [
      # https://github.com/NixOS/nixpkgs/blob/nixos-22.11/nixos/modules/tasks/auto-upgrade.nix#L204
      (writeShellApplication {
        name = "needs-reboot";
        runtimeInputs = [ coreutils ];
        text = ''
          booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
          built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

          if [ "$booted" != "$built" ]; then
            echo "REBOOT NEEDED"
          fi
        '';
      })
    ];
  };
}
