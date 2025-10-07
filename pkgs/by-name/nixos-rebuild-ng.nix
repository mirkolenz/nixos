{ prev, determinate-nix }:
(prev.nixos-rebuild-ng.override {
  nix = determinate-nix;
}).overrideAttrs
  (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // {
      updateScript = null;
    };
  })
