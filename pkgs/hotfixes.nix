final: prev:
{ }
// (prev.lib.optionalAttrs prev.stdenv.isLinux {
})
// (prev.lib.optionalAttrs prev.stdenv.isDarwin {
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/tealdeer.aarch64-darwin
    tealdeer
    ;
})
// (prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "x86_64-darwin") {
  container = final.empty;
  ncdu = final.empty;
})
