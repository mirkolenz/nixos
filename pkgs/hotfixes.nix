final: prev:
{
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/llm.aarch64-darwin
    llm
    # https://hydra.nixos.org/job/nixpkgs/trunk/mcp-proxy.aarch64-darwin
    mcp-proxy
    ;
}
// (prev.lib.optionalAttrs prev.stdenv.isLinux {
})
// (prev.lib.optionalAttrs prev.stdenv.isDarwin {
})
