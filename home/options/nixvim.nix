{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.nixvim;
in
{
  options = {
    programs.nixvim = {
      enable = lib.mkEnableOption "nixvim";
      package = lib.mkPackageOption pkgs "nixvim" { nullable = true; };
      defaultEditor = lib.mkEnableOption "set vim as default editor";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = lib.mkIf (cfg.package != null) [ cfg.package ];
      sessionVariables = lib.mkIf cfg.defaultEditor {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  };
}
