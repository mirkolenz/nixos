{ ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      packages.checks = pkgs.symlinkJoin {
        name = "checks";
        paths = builtins.attrValues config.checks;
      };
    };
}
