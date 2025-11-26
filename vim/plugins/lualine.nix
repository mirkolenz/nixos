{ ... }:
{
  plugins.lualine = {
    settings = {
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          "branch"
          "diff"
          "diagnostics"
        ];
        lualine_c = [ "filename" ];
        lualine_x = [
          "encoding"
          "fileformat"
          "filetype"
        ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
      inactive_sections = {
        lualine_a = [ ];
        lualine_b = [ ];
        lualine_c = [ "filename" ];
        lualine_x = [ "location" ];
        lualine_y = [ ];
        lualine_z = [ ];
      };
      tabline = {
        lualine_a = [ "tabs" ];
        lualine_b = [ "buffers" ];
        lualine_c = [ ];
        lualine_x = [ ];
        lualine_y = [ ];
        lualine_z = [ ];
      };
      winbar = {
        lualine_a = [ ];
        lualine_b = [ ];
        lualine_c = [ ];
        lualine_x = [ ];
        lualine_y = [ ];
        lualine_z = [ ];
      };
      inactive_winbar = {
        lualine_a = [ ];
        lualine_b = [ ];
        lualine_c = [ ];
        lualine_x = [ ];
        lualine_y = [ ];
        lualine_z = [ ];
      };
    };
  };
}
