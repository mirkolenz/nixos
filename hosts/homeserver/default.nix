{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    # ./samba.nix
    ../../templates/server.nix
  ];
  networking.hostName = "homeserver";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };
}
