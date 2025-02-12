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
      package = lib.mkPackageOption pkgs "nvim" { };
      defaultEditor = (lib.mkEnableOption "set vim as default editor") // {
        default = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = lib.singleton cfg.package;
      sessionVariables = {
        EDITOR = lib.mkIf cfg.defaultEditor (lib.mkDefault "nvim");
      };
    };
  };
}
