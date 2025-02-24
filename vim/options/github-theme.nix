{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "github-theme";
  packPathName = "github-nvim-theme";
  package = "github-nvim-theme";
  isColorscheme = true;
  colorscheme = null;

  maintainers = with lib.maintainers; [ mirkolenz ];

  extraOptions = {
    colorscheme = defaultNullOpts.mkEnumFirstDefault [
      "github_dark"
      "github_light"
      "github_dark_dimmed"
      "github_dark_default"
      "github_light_default"
      "github_dark_high_contrast"
      "github_light_high_contrast"
      "github_dark_colorblind"
      "github_light_colorblind"
      "github_dark_tritanopia"
      "github_light_tritanopia"
    ] "The name of the colorscheme";
  };

  extraConfig = cfg: {
    inherit (cfg) colorscheme;
    opts.termguicolors = lib.mkDefault true;
  };
}
