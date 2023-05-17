{ lib, pkgs, extras, ... }:
let
  inherit (extras) pkgsUnstable;
in
{
  imports = [
    ./sd.nix
  ];
  # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
  # TODO: Remove for 23.05
  boot.kernelPackages = lib.mkDefault pkgsUnstable.linuxKernel.packages.linux_rpi4;
}
