final: prev:
let
  pkgs = final.stable;
  inherit (prev) lib;
in
# todo: https://hydra.nixos.org/job/nixpkgs/trunk/virt-manager.aarch64-darwin
pkgs.virt-manager.overrideAttrs (oldAttrs: {
  nativeBuildInputs =
    (oldAttrs.nativeBuildInputs or [ ])
    ++ (lib.optional pkgs.stdenv.hostPlatform.isDarwin pkgs.makeBinaryWrapper);
  postInstall =
    (oldAttrs.postInstall or "")
    + (lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      wrapProgram $out/bin/virt-manager \
        --set GSETTINGS_BACKEND keyfile
    '');
  meta = oldAttrs.meta // {
    hydraPlatforms = lib.platforms.darwin;
  };
})
