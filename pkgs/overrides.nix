final: prev:
{ }
// (prev.lib.optionalAttrs prev.stdenv.isDarwin {
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/basedpyright.aarch64-darwin
    basedpyright
    # https://hydra.nixos.org/job/nixpkgs/trunk/virt-manager.aarch64-darwin
    vte
    # https://hydra.nixos.org/job/nixpkgs/trunk/time.aarch64-darwin
    time
    ;
})
// (prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "x86_64-darwin") {
  ncdu = final.empty;
})
