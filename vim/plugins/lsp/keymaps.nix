{ lib', ... }:
{
  keymaps =
    lib'.self.mkVimKeymaps
      {
        prefix = "vim.lsp.";
        raw = true;
      }
      [
        {
          key = "<leader>bf";
          mode = [
            "n"
            "x"
          ];
          action = "buf.format()";
          options.desc = "Format buffer";
        }
        {
          key = "g.";
          mode = [
            "n"
            "x"
          ];
          action = "buf.code_action()";
          options.desc = "Code action";
        }
      ];
}
