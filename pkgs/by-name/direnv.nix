{ prev, stdenv }:
prev.direnv.overrideAttrs (prevAttrs: {
  # https://github.com/NixOS/nixpkgs/pull/513081
  # https://github.com/NixOS/nixpkgs/issues/208951
  doCheck = !stdenv.hostPlatform.isDarwin;
})
