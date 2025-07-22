{ ... }:
final: prev: {
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/git-annex.x86_64-darwin
    git-annex
    ;
}
