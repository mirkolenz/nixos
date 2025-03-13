{ pkgs, ... }:
{
  plugins.lsp.servers.texlab = {
    enable = true;
    settings.texlab = {
      bibtexFormatter = "tex-fmt";
      latexFormatter = "tex-fmt";
      inlayHints = {
        labelDefinitions = false;
        labelReferences = false;
        maxLength = 32;
      };
      build = {
        onSave = false;
        forwardSearchAfter = true;
      };
      # https://github.com/latex-lsp/texlab/wiki/Previewing
      # https://github.com/rzukic/zed-latex/blob/main/src/preview_presets.rs
      forwardSearch =
        if pkgs.stdenv.isDarwin then
          {
            # displayline -h
            executable = "displayline";
            args = [
              "-r"
              "-g"
              "%l"
              "%p"
              "%f"
            ];
          }
        else
          {
            executable = "sioyek";
            args = [
              "--reuse-window"
              "--nofocus"
              "--execute-command"
              "turn_on_synctex"
              "--forward-search-file"
              "%f"
              "--forward-search-line"
              "%l"
              "%p"
            ];
          };
    };
  };
  files."ftplugin/tex.lua" = {
    keymaps = [
      {
        key = "<leader>tb";
        mode = "n";
        action = "<cmd>TexlabWriteBuild<CR>";
        options.desc = "Write and build the document";
      }
      {
        key = "<leader>tB";
        mode = "n";
        action = "<cmd>TexlabCancelBuild<CR>";
        options.desc = "Cancel the current build";
      }
      {
        key = "<leader>tc";
        mode = "n";
        action = "<cmd>TexlabCleanAuxiliary<CR>";
        options.desc = "Clean auxiliary files";
      }
      {
        key = "<leader>tC";
        mode = "n";
        action = "<cmd>TexlabCleanArtifacts<CR>";
        options.desc = "Clean auxiliary and output files";
      }
    ];
    userCommands = {
      TexlabWriteBuild = {
        command = "write | TexlabBuild";
        desc = "Write and build the document";
      };
    };
  };
}
