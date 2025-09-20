final: prev: {
  nixos-rebuild-ng =
    (prev.nixos-rebuild-ng.override {
      nix = final.determinate-nix;
    }).overrideAttrs
      (oldAttrs: {
        meta = (oldAttrs.meta or { }) // {
          githubActionsCheck = true;
        };
      });

  sambaTimeMachine =
    (prev.samba4.override {
      enableMDNS = true;
    }).overrideAttrs
      (oldAttrs: {
        meta = (oldAttrs.meta or { }) // {
          githubActionsCheck = prev.stdenv.hostPlatform.system == "x86_64-linux";
        };
      });
}
