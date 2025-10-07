{
  prev,
  lib,
  makeBinaryWrapper,
}:
prev.virt-manager.overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or { }) // {
    updateScript = null;
  };
  nativeBuildInputs =
    (oldAttrs.nativeBuildInputs or [ ]) ++ (lib.optional prev.stdenv.isDarwin makeBinaryWrapper);
  postInstall =
    (oldAttrs.postInstall or "")
    + (lib.optionalString prev.stdenv.isDarwin ''
      wrapProgram $out/bin/virt-manager \
        --set GSETTINGS_BACKEND keyfile
    '');
})
