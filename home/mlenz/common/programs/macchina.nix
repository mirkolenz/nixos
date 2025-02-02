{ pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  home.packages = with pkgs; [ macchina ];
  xdg.configFile = {
    # https://github.com/Macchina-CLI/macchina/blob/main/contrib/themes/Lithium.toml
    "macchina/themes/custom.toml".source = tomlFormat.generate "macchina-theme" {
      spacing = 1;
      padding = 0;
      hide_ascii = true;
      separator = " ";
      key_color = "Yellow";
      separator_color = "Yellow";
      palette = {
        type = "Light";
        glyph = " ● ";
        visible = false;
      };
      bar = {
        glyph = "●";
        symbol_open = "(";
        symbol_close = ")";
        visible = false;
        hide_delimiters = true;
      };
      box = {
        title = " ";
        border = "plain";
        visible = false;
        inner_margin = {
          x = 2;
          y = 1;
        };
      };
      custom_ascii.color = "Yellow";
      randomize = {
        key_color = false;
        separator_color = false;
        pool = "base";
      };
    };
    # https://github.com/Macchina-CLI/macchina/blob/main/macchina.toml
    "macchina/macchina.toml".source = tomlFormat.generate "macchina-config" {
      long_uptime = false;
      long_shell = false;
      long_kernel = false;
      current_shell = true;
      physical_cores = true;
      theme = "custom";
    };
  };
}
