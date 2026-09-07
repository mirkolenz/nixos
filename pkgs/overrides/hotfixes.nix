final: prev:
{ }
// (prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
})
// (prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyFinal: pyPrev: {
      # Interactive Zsh completion tests capture unreliable terminal output on Darwin.
      cyclopts = pyPrev.cyclopts.overridePythonAttrs (prevAttrs: {
        disabledTestPaths = (prevAttrs.disabledTestPaths or [ ]) ++ [ "tests/completion/test_zsh.py" ];
        disabledTests = (prevAttrs.disabledTests or [ ]) ++ [ "test_behavior[zsh-" ];
      });

      # Libvirt's test driver cannot create checkpoints or report an active domain ID on Darwin.
      libvirt-python = pyPrev.libvirt-python.overridePythonAttrs (prevAttrs: {
        disabledTests = (prevAttrs.disabledTests or [ ]) ++ [
          "testCheckpointCreate"
          "testDomainIDReturnsValidValue"
        ];
      });
    })
  ];
})
