{ lib, ... }:
{
  options.custom.impure_rebuild = lib.mkEnableOption "impure rebuild";
}
