{ ... }:
{
  plugins.copilot-lua = {
    enable = true;
    settings = {
      filetypes = {
        "*" = true;
      };
      panel = {
        enabled = true;
        auto_refresh = true;
        keymap = {
          jump_prev = "[[";
          jump_next = "]]";
          accept = "<CR>";
          refresh = "gr";
          open = "<M-CR>";
        };
        layout = {
          position = "bottom"; # | top | left | right | horizontal | vertical
          ratio = 0.4;
        };
      };
      suggestion = {
        enabled = true;
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
