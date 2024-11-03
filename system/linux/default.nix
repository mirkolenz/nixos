{
  config,
  lib',
  pkgs,
  stateVersions,
  ...
}:
{
  imports = [ ../common ] ++ (lib'.flocken.getModules ./.);

  custom.podman.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.fish;
  };

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
    _1password.enable = true;
  };

  environment.defaultPackages = with pkgs; [
    rsync
    python3
    strace
  ];

  services = {
    printing.enable = false;
  };

  system.stateVersion = stateVersions.linux;

  security = {
    sudo = {
      execWheelOnly = true;
    };
    sudo-rs = {
      enable = true;
      inherit (config.security.sudo) execWheelOnly wheelNeedsPassword;
    };
  };

  boot.loader = {
    systemd-boot.configurationLimit = 7;
    generic-extlinux-compatible.configurationLimit = 7;
    grub.configurationLimit = 7;
    raspberryPi.uboot.configurationLimit = 7;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    memoryMax = 8 * 1024 * 1024 * 1024;
  };
}
