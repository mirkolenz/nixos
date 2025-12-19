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
    args@{ ghBin, ... }:
    let
      ghDrv = mkGitHubBinary ghBin;
    in
    {
      pname = args.pname or ghDrv.pname;
      version = args.version or ghDrv.version;
      src = args.src or ghDrv.src;
      passthru = (ghDrv.passthru or { }) // (args.passthru or { });
      meta = (ghDrv.meta or { }) // (args.meta or { });
    };
}
