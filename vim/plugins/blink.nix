{ config, ... }:
{
  plugins.blink-cmp = {
    enable = true;
    settings = {
      completion = {
        ghost_text = {
          enabled = true;
        };
        documentation = {
          auto_show = true;
        };
        keyword = {
          range = "full";
        };
        menu.draw.components.label.width = {
          fill = true;
          max = 120;
        };
      };
      appearance = {
        kind_icons = { };
      };
      keymap = {
        preset = "enter";
      };
      signature = {
        enabled = true;
      };
      sources = {
        default = [
          "lsp"
          "path"
          "snippets"
          # "luasnip"
          # "buffer"
          "copilot"
        ];
        providers = {
          copilot = {
            async = true;
            module = "blink-copilot";
            name = "Copilot";
            score_offset = 100;
            opts = { };
          };
          emoji = {
            module = "blink-emoji";
            name = "Emoji";
            score_offset = 15;
            opts = { };
          };
        };
      };
    };
  };
  plugins.blink-copilot = {
    inherit (config.plugins.blink-cmp) enable;
  };
  plugins.blink-emoji = {
    inherit (config.plugins.blink-cmp) enable;
  };
}
