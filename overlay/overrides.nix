{ ... }:
final: prev: {
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/git-annex.x86_64-darwin
    git-annex
    ;
  inherit (final.unstable-small)
    # https://nixpk.gs/pr-tracker.html?pr=427427
    hydra-check
    ;
}
