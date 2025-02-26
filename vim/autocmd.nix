{ lib, ... }:
{
  autoGroups = {
    autocd.clear = true;
  };
  autoCmd = [
    {
      callback = lib.nixvim.mkRaw ''
        function()
          local path = vim.fn.argv(0)

          if vim.fn.isdirectory(path) == 0 then
            path = vim.fn.fnamemodify(path, ":h")
          end

          vim.fn.chdir(path)
        end
      '';
      event = "VimEnter";
      pattern = "*";
      group = "autocd";
      desc = "Change directory to current working directory";
    }
  ];
}
