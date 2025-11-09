final: prev:
prev.virt-manager.overrideAttrs (oldAttrs: {
  nativeBuildInputs =
    (oldAttrs.nativeBuildInputs or [ ])
    ++ (prev.lib.optional prev.stdenv.isDarwin prev.makeBinaryWrapper);
  postInstall =
    (oldAttrs.postInstall or "")
    + (prev.lib.optionalString prev.stdenv.isDarwin ''
      wrapProgram $out/bin/virt-manager \
        --set GSETTINGS_BACKEND keyfile
    '');
  meta = oldAttrs.meta // {
    hydraPlatforms = prev.lib.platforms.darwin;
  };
})
