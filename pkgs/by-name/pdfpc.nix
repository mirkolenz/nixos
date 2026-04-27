# https://github.com/pdfpc/pdfpc
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/misc/pdfpc/default.nix
{
  prev,
  lib,
  libsoup_3,
}:
(prev.pdfpc.override {
  # broken on darwin
  webkitgtk_4_1 = null;
}).overrideAttrs
  (prevAttrs: {
    buildInputs = (prevAttrs.buildInputs or [ ]) ++ [
      libsoup_3
    ];
    cmakeFlags = (prevAttrs.cmakeFlags or [ ]) ++ [
      # needs webkitgtk
      (lib.cmakeBool "MDVIEW" false)
    ];
    passthru.updateScript = null;
  })
