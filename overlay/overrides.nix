{ ... }:
final: prev: {
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/git-annex.x86_64-darwin
    git-annex
    # https://github.com/nix-community/hydra-check/issues/79
    hydra-check
    ;
}
