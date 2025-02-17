{ config, ... }:
{
  plugins.blink-cmp = {
    enable = true;
    settings = {
      signature.enabled = true;
      completion = {
        ghost_text.enabled = false;
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 0;
          update_delay_ms = 0;
        };
        keyword.range = "full";
        menu.draw.components.label.width.max = 60;
        list.selection = {
          auto_insert = false;
          preselect = false;
          # lib.nixvim.mkRaw ''
          #   function(ctx)
          #     return not require('blink.cmp').snippet_active({ direction = 1 })
          #   end
          # '';
        };
      };
      # https://cmp.saghen.dev/configuration/keymap#presets
      keymap = {
        preset = "super-tab";
        "<CR>" = [
          "accept"
          "fallback"
        ];
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
