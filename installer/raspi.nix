{ ... }:
{
  imports = [
    ./sd.nix
    ../fixes/raspi4-kernel.nix
  ];
  # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
}
