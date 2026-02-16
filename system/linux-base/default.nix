{
  config,
  lib',
  stateVersions,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  system.stateVersion = stateVersions.linux;

  programs = {
    git.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    less.enable = true;
  };

  environment.defaultPackages = [ ];

  services.printing.enable = false;

  security = {
    sudo = {
      execWheelOnly = true;
    };
    sudo-rs = {
      enable = true;
      inherit (config.security.sudo) execWheelOnly wheelNeedsPassword;
    };
  };

  # todo: fails on raspi (mkswap-swapfile-start)
  systemd.enableStrictShellChecks = false;

  documentation = {
    nixos.enable = false;
    # this is slow
    man.generateCaches = false;
  };

  boot.loader = {
    generic-extlinux-compatible.configurationLimit = 10;
    grub.configurationLimit = 10;
    systemd-boot.configurationLimit = 10;
  };
  boot.initrd.systemd.enable = true;

  hardware.enableAllFirmware = true;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    memoryMax = 8 * 1024 * 1024 * 1024;
  };
}
