{ pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/issues/191095#issuecomment-1324031096
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
}
