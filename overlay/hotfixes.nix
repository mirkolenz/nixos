{ ... }:
final: prev: {
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/ffmpeg-normalize.x86_64-darwin
    ffmpeg-normalize
    # https://hydra.nixos.org/job/nixpkgs/trunk/gitui.x86_64-darwin
    gitui
    # https://hydra.nixos.org/job/nixpkgs/trunk/tectonic.x86_64-darwin
    tectonic
    ;
}
