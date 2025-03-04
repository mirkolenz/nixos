{ ... }:
{
  plugins.copilot-vim = {
    enable = false;
    settings = {
      filetypes = {
        "*" = true;
      };
    };
  };
  plugins.copilot-lua = {
    enable = true;
    settings = {
      filetypes = {
        "*" = true;
      };
      panel = {
        enabled = false; # handled by blink-cmp
        auto_refresh = true;
        keymap = {
          jump_prev = "[[";
          jump_next = "]]";
          accept = "<CR>";
          refresh = "gr";
          open = "<M-CR>";
        };
        layout = {
          position = "bottom";
          ratio = 0.4;
        };
      };
      suggestion = {
        enabled = false; # handled by blink-cmp
        auto_trigger = true;
        hide_during_completion = false;
        keymap = {
          accept_word = "<M-l>";
          accept_line = "<M-;>";
          accept = "<M-'>";
          dismiss = "<C-'>";
          prev = "<M-j>";
          next = "<M-k>";
        };
      };
    };
  };
}
