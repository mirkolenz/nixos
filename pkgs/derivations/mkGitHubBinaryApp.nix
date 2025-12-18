{
  lib,
  mkApp,
  mkGitHubBinary,
}:
lib.extendMkDerivation {
  constructDrv = mkApp;
  excludeDrvArgNames = [
    "ghBin"
  ];
  extendDrvArgs =
    finalAttrs:
    { ghBin, ... }:
    let
      ghBinary = mkGitHubBinary ghBin;
    in
    {
      inherit (ghBinary)
        pname
        version
        src
        passthru
        meta
        ;
    };
}
