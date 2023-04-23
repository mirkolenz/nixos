{ pkgs, ... }:
{
  imports = [
    ./hardware-qemu.nix
    ../../templates/workstation.nix
  ];
  services.openssh.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  networking.hostName = "nixos-vm";
  services.vscode-server.enable = true;
  # Parallels
  # boot.loader.grub = {
  #   enable = true;
  #   device = "/dev/sda";
  # };
  # QEMU
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/efi";
      canTouchEfiVariables = true;
    };
    systemd-boot.enable = true;
  };
}
