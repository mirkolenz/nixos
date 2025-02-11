{ lib, ... }:
{
  options.custom.impureRebuild = lib.mkEnableOption "impure rebuild";
}
