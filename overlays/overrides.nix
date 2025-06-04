{ ... }:
final: prev: {
  inherit (final.unstable-small)
    ruff
    ty
    uv
    ;
}
