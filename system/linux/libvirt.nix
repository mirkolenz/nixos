{ ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/virtualisation/libvirtd.nix
  virtualisation.libvirtd.qemu.runAsRoot = false;

  # https://github.com/AshleyYakeley/NixVirt
  virtualisation.libvirt = {
    # enable = true;
    swtpm.enable = true;
  };
}
