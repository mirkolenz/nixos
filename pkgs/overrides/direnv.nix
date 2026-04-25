final: prev:
let
  pkgs = prev;
in
pkgs.direnv.overrideAttrs (prevAttrs: {
  # https://github.com/NixOS/nixpkgs/pull/513081
  # https://github.com/NixOS/nixpkgs/issues/208951
  doCheck = !pkgs.stdenv.hostPlatform.isDarwin;
})
