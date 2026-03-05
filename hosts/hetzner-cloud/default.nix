{ ... }:
{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  custom.profile.isServer = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  users.users.root.hashedPasswordFile = null;
}
