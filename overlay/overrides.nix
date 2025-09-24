final: prev:
let
  lib = prev.lib;
in
{
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

  # https://github.com/NixOS/nixpkgs/issues/294640
  virt-manager = prev.virt-manager.overrideAttrs (oldAttrs: {
    nativeBuildInputs =
      (oldAttrs.nativeBuildInputs or [ ]) ++ (lib.optional prev.stdenv.isDarwin final.makeWrapper);
    postInstall =
      (oldAttrs.postInstall or "")
      + (lib.optionalString prev.stdenv.isDarwin ''
        wrapProgram $out/bin/virt-manager \
          --set GSETTINGS_BACKEND keyfile
      '');
  });
}
