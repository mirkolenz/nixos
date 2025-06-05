{
  config,
  lib',
  pkgs,
  stateVersions,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

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

  environment.systemPackages = with pkgs; [
    pciutils
  ];

  services = {
    printing.enable = false;
  };

  system.stateVersion = stateVersions.linux;
  system.rebuild.enableNg = true;

  security = {
    sudo = {
      execWheelOnly = true;
    };
    sudo-rs = {
      enable = true;
      inherit (config.security.sudo) execWheelOnly wheelNeedsPassword;
    };
  };

  systemd.enableStrictShellChecks = true;
  documentation.man.generateCaches = false;

  boot.loader = {
    systemd-boot.configurationLimit = 10;
    generic-extlinux-compatible.configurationLimit = 10;
    grub.configurationLimit = 10;
  };

  hardware.enableAllFirmware = true;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    memoryMax = 8 * 1024 * 1024 * 1024;
  };
}
