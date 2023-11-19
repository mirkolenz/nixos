{
  pkgs,
  stateVersion,
  ...
}: {
  imports = [
    ../common
    ./cuda.nix
    ./docker.nix
    ./ssh.nix
    ./xserver.nix
  ];

  custom.docker.enable = true;

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

  environment.defaultPackages = with pkgs; [
    rsync
    python3Minimal
    strace
  ];

  system = {
    inherit stateVersion;
  };

  security.sudo = {
    execWheelOnly = true;
  };

  boot.loader = {
    systemd-boot.configurationLimit = 7;
    generic-extlinux-compatible.configurationLimit = 7;
    grub.configurationLimit = 7;
    raspberryPi.uboot.configurationLimit = 7;
  };
}
