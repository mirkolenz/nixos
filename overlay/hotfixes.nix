{ ... }:
final: prev: {
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/ffmpeg-normalize.aarch64-darwin
    ffmpeg-normalize
    # https://hydra.nixos.org/job/nixpkgs/trunk/ttfautohint.aarch64-darwin
    ttfautohint
    ;
}
