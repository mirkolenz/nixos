{ lib, config, ... }:
{
  globals = lib.mkIf config.plugins.copilot-vim.enable {
    copilot_settings = {
      selectedCompletionModel = "gpt-4o-copilot";
    };
    copilot_no_tab_map = true;
    copilot_integration_id = "vscode-chat";
  };
  keymaps = lib.mkIf config.plugins.copilot-vim.enable [
    {
      key = "<M-;>";
      mode = "i";
      action = "copilot#Accept(\"<CR>\")";
      options = {
        expr = true;
        silent = true;
        replace_keycodes = false;
        desc = "Accept Copilot suggestion";
      };
    }
    {
      key = "<M-l>";
      mode = "i";
      action = "<Plug>(copilot-accept-line)";
      options.desc = "Accept Copilot line";
    }
    {
      key = "<M-k>";
      mode = "i";
      action = "<Plug>(copilot-accept-word)";
      options.desc = "Accept Copilot word";
    }
    {
      key = "<M-'>";
      mode = "i";
      action = "<Plug>(copilot-dismiss)";
      options.desc = "Dismiss Copilot suggestion";
    }
    {
      key = "<M-n>";
      mode = "i";
      action = "<Plug>(copilot-next)";
      options.desc = "Next Copilot suggestion";
    }
    {
      key = "<M-p>";
      mode = "i";
      action = "<Plug>(copilot-previous)";
      options.desc = "Next Copilot suggestion";
    }
  ];
  plugins.copilot-vim = {
    enable = true;
    settings = {
      filetypes = {
        "*" = true;
      };
    };
  };
  plugins.copilot-lua = {
    enable = false;
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
          position = "bottom";
          ratio = 0.4;
        };
      };
      suggestion = {
        enabled = true;
        auto_trigger = true;
        hide_during_completion = false;
        keymap = {
          accept = "<M-;>";
          accept_line = "<M-l>";
          accept_word = "<M-k>";
          dismiss = "<M-'>";
          next = "<M-n>";
          prev = "<M-p>";
        };
      };
    };
  };
}
