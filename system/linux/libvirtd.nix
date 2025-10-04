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
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      vhostUserPackages = [ pkgs.virtiofsd ];
      swtpm.enable = true;
    };
  };

  users.users.${user.login}.extraGroups = lib.mkIf config.virtualisation.libvirtd.enable [
    "libvirtd"
  ];

  programs.virt-manager.enable = lib.mkDefault config.custom.profile.isDesktop;

  environment.systemPackages = lib.mkIf config.custom.profile.isDesktop [
    pkgs.virt-viewer
  ];

  environment.etc = lib.mkIf config.virtualisation.libvirtd.enable {
    "nix-libvirtd/images/virtio-win.iso".source = pkgs.virtio-win.src;
  };
}
