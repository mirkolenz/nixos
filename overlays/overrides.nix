{ ... }:
final: prev: {
  # https://nixpk.gs/pr-tracker.html?pr=423992
  inherit (final.unstable-small) nixos-rebuild-ng;
}
