{
  pkgs,
  config,
  lib,
  user,
  ...
}:
{
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/virtualisation/libvirtd.nix
  virtualisation.libvirtd = {
    qemu.package = pkgs.qemu_kvm;
    qemu.runAsRoot = false;
  };

  # https://github.com/AshleyYakeley/NixVirt
  virtualisation.libvirt = {
    swtpm.enable = true;
  };

  users.users.${user.login}.extraGroups = lib.mkIf config.virtualisation.libvirtd.enable [
    "libvirt"
  ];

  # graphical interfaces
  programs.virt-manager.enable = lib.mkDefault config.custom.profile.isDesktop;
  environment.systemPackages = lib.mkIf config.custom.profile.isDesktop [
    pkgs.virt-viewer
  ];
}
