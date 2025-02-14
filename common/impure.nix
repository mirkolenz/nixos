args@{
  lib,
  ...
}:
let
  osConfig = args.osConfig or { };
in
{
  options.custom.impureRebuild = lib.mkEnableOption "impure rebuild";
  config.custom.impureRebuild = lib.mkIf (osConfig != { }) (
    lib.mkDefault osConfig.custom.impureRebuild
  );
}
