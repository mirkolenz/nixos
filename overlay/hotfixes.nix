{ ... }:
final: prev: {
  # https://github.com/NixOS/nixpkgs/issues/438765#issuecomment-3281041188
  tailscale = prev.tailscale.overrideAttrs { doCheck = false; };
}
