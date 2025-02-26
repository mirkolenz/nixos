{ ... }:
{
  plugins.fzf-lua = {
    enable = true;
    keymaps = {
      "<leader>," = "buffers";
      "<leader>/" = "command_history";
      "<leader><space>" = "files";
      # find
      "<leader>fb" = "buffers";
      "<leader>ff" = "files";
      "<leader>fg" = "git_files";
      "<leader>fh" = "tags";
      "<leader>fr" = "oldfiles";
      "<leader>ft" = "tabs";
      # git
      "<leader>gc" = "git_commits";
      "<leader>gs" = "git_status";
      # search
      "<leader>s\"" = "registers";
      "<leader>sa" = "autocmds";
      "<leader>sb" = "grep_curbuf";
      "<leader>sc" = "command_history";
      "<leader>sC" = "commands";
      "<leader>sd" = "diagnostics_document";
      "<leader>sD" = "diagnostics_workspace";
      "<leader>sg" = "live_grep";
      "<leader>sh" = "help_tags";
      "<leader>sH" = "highlights";
      "<leader>sj" = "jumps";
      "<leader>sk" = "keymaps";
      "<leader>sl" = "loclist";
      "<leader>sM" = "man_pages";
      "<leader>sm" = "marks";
      "<leader>sq" = "quickfix";
      "<leader>sR" = "resume";
      "<leader>sw" = "grep_cword";
      "<leader>sW" = "grep_cword";
      "<leader>uC" = "colorschemes";
    };
  };
}
