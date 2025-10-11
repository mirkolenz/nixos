final: prev:
prev.virt-manager.overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or { }) // {
    updateScript = null;
  };
  nativeBuildInputs =
    (oldAttrs.nativeBuildInputs or [ ])
    ++ (prev.lib.optional prev.stdenv.isDarwin prev.makeBinaryWrapper);
  postInstall =
    (oldAttrs.postInstall or "")
    + (prev.lib.optionalString prev.stdenv.isDarwin ''
      wrapProgram $out/bin/virt-manager \
        --set GSETTINGS_BACKEND keyfile
    '');
})
