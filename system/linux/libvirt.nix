{ pkgs, config, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/virtualisation/libvirtd.nix
  virtualisation.libvirtd = {
    qemu.package = pkgs.qemu_kvm;
    qemu.runAsRoot = false;
  };

  # https://github.com/AshleyYakeley/NixVirt
  virtualisation.libvirt = {
    # enable = true;
    swtpm.enable = true;
  };

  programs.virt-manager.enable =
    config.custom.profile.isDesktop && config.virtualisation.libvirtd.enable;
}
