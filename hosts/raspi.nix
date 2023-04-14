{ config, pkgs, lib, ... }:

{
  imports = [
    .../nixos-hardware/raspberry-pi/4
  ];

  # GPU
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/audio.nix
  hardware.raspberry-pi."4".audio.enable = true;

  # PoE Hat
  # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/poe-plus-hat.nix
  hardware.raspberry-pi."4".poe-plus-hat.enable = true;

  # General config
  # https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_4
  boot.loader.raspberryPi.firmwareConfig = ''
    dtparam=audio=on
  '';

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
        "8250.nr_uarts=1"
        "console=ttyAMA0,115200"
        "console=tty1"
        # A lot GUI programs need this, nearly all wayland applications
        "cma=128M"
    ];
  };

  boot.loader.raspberryPi = {
    enable = true;
    version = 4;
  };
  boot.loader.grub.enable = false;

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "nixos-raspi-4"; # Define your hostname.
    networkmanager = {
      enable = true;
    };
  };

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };
}
