{ lib', lib, ... }:
{
  plugins.multicursor-nvim = {
    enable = true;
    keymapsLayer = [
      # Select a different cursor as the main one
      {
        key = "<left>";
        mode = [
          "n"
          "x"
        ];
        action = "prevCursor";
      }
      {
        key = "<right>";
        mode = [
          "n"
          "x"
        ];
        action = "nextCursor";
      }
      # Delete the main cursor
      {
        key = "<leader>x";
        mode = [
          "n"
          "x"
        ];
        action = "deleteCursor";
      }
      {
        # Enable and clear cursors using escape
        key = "<esc>";
        mode = "n";
        action = lib.nixvim.mkRaw ''
          mc = require('multicursor-nvim')
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        '';
      }
    ];
  };
  keymaps =
    lib'.self.mkVimKeymaps
      {
        prefix = "require('multicursor-nvim').";
        raw = true;
      }
      [
        {
          key = "<C-q>";
          mode = [
            "n"
            "x"
          ];
          action = "toggleCursor()";
          options.desc = "Toggle multicursor";
        }
        # Add or skip cursor above/below the main cursor
        {
          key = "<up>";
          mode = [
            "n"
            "x"
          ];
          action = "lineAddCursor(-1)";
          options.desc = "Add cursor above";
        }
        {
          key = "<down>";
          mode = [
            "n"
            "x"
          ];
          action = "lineAddCursor(1)";
          options.desc = "Add cursor below";
        }
        {
          key = "<leader><up>";
          mode = [
            "n"
            "x"
          ];
          action = "lineSkipCursor(-1)";
          options.desc = "Skip cursor above";
        }
        {
          key = "<leader><down>";
          mode = [
            "n"
            "x"
          ];
          action = "lineSkipCursor(1)";
          options.desc = "Skip cursor below";
        }
        # Add or skip adding a new cursor by matching word/selection
        {
          key = "<leader>n";
          mode = [
            "n"
            "x"
          ];
          action = "matchAddCursor(1)";
          options.desc = "Add next matching cursor";
        }
        {
          key = "<leader>s";
          mode = [
            "n"
            "x"
          ];
          action = "matchSkipCursor(1)";
          options.desc = "Skip next matching cursor";
        }
        {
          key = "<leader>N";
          mode = [
            "n"
            "x"
          ];
          action = "matchAddCursor(-1)";
          options.desc = "Add previous matching cursor";
        }
        {
          key = "<leader>S";
          mode = [
            "n"
            "x"
          ];
          action = "matchSkipCursor(-1)";
          options.desc = "Skip previous matching cursor";
        }
        # Add and remove cursors with control + left click
        {
          key = "<C-leftmouse>";
          mode = "n";
          action = "handleMouse()";
          options.desc = "Handle multicursor mouse";
        }
        {
          key = "<C-leftdrag>";
          mode = "n";
          action = "handleMouseDrag()";
          options.desc = "Handle multicursor mouse drag";
        }
        {
          key = "<C-leftrelease>";
          mode = "n";
          action = "handleMouseRelease()";
          options.desc = "Handle multicursor mouse release";
        }
      ];
}
