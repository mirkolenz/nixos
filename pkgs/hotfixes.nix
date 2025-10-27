final: prev:
{ }
// (prev.lib.optionalAttrs prev.stdenv.isLinux {
})
// (prev.lib.optionalAttrs prev.stdenv.isDarwin {
})
// (prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "x86_64-darwin") {
  container = final.empty;
  ncdu = final.empty;
})
