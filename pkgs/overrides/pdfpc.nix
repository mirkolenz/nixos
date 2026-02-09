# https://github.com/pdfpc/pdfpc
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/misc/pdfpc/default.nix
final: prev:
let
  pkgs = prev;
  inherit (pkgs) lib;
in
(pkgs.pdfpc.override {
  # broken on darwin
  webkitgtk_4_1 = null;
}).overrideAttrs
  (prevAttrs: {
    buildInputs = (prevAttrs.buildInputs or [ ]) ++ [
      pkgs.libsoup_3
    ];
    cmakeFlags = (prevAttrs.cmakeFlags or [ ]) ++ [
      # needs webkitgtk
      (lib.cmakeBool "MDVIEW" false)
    ];
  })
