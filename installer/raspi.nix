{...}: {
  imports = [
    ./sd.nix
  ];
  # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  nixpkgs.overlays = [
    (final: prev: {
      makeModulesClosure = x:
        prev.makeModulesClosure (x // {allowMissing = true;});
    })
  ];
}
