# https://github.com/pdfpc/pdfpc
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/misc/pdfpc/default.nix
final: prev:
(prev.pdfpc.override {
  # broken on darwin
  webkitgtk_4_1 = null;
}).overrideAttrs
  (prevAttrs: {
    buildInputs = (prevAttrs.buildInputs or [ ]) ++ [
      prev.libsoup_3
    ];
    cmakeFlags = (prevAttrs.cmakeFlags or [ ]) ++ [
      # needs webkitgtk
      (prev.lib.cmakeBool "MDVIEW" false)
    ];
    passthru = prevAttrs.passthru // {
      updateScript = null;
    };
  })
