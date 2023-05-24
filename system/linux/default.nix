{ lib, pkgs, extras, config, ... }:
{
  imports = [
    ./docker.nix
    ./ssh.nix
    ./xserver.nix
  ];

  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.fish;
  };

  # Currently produces an error on darwin
  # https://github.com/LnL7/nix-darwin/issues/359
  time.timeZone = "Europe/Berlin";

  programs = {
    git = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  environment.systemPackages = with pkgs; [
    mkpasswd
    macchina
  ] ++ ([
    (writeShellScriptBin "nixos-env" "nix-env --profile /nix/var/nix/profiles/system")
  ]);

  environment.defaultPackages = with pkgs; [
    rsync
    python3Minimal
    strace
  ];

  system = {
    inherit (extras) stateVersion;
  };
}
