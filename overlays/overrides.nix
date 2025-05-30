{ ... }:
final: prev: {
  inherit (final.unstable-small)
    claude-code
    ruff
    ty
    uv
    ;
}
