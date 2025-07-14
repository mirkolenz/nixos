{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.custom.neovim;
in
{
  options = {
    custom.neovim = {
      enable = lib.mkEnableOption "neovim";
      package = lib.mkPackageOption pkgs "neovim" { nullable = true; };
      defaultEditor = (lib.mkEnableOption "set vim as default editor") // {
        default = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = lib.mkIf (cfg.package != null) [ cfg.package ];
      sessionVariables = {
        EDITOR = lib.mkIf cfg.defaultEditor (lib.mkDefault "nvim");
      };
    };
  };
}
