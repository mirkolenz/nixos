{ lib, ... }:
{
  autoGroups = {
    autoformat.clear = true;
  };
  autoCmd = [
    {
      callback = lib.nixvim.mkRaw ''
        function(args)
          vim.lsp.buf.format({
            async = false,
            bufnr = args.buf,
            timeout_ms = 1000,
          })
        end
      '';
      event = "BufWritePre";
      pattern = "*";
      group = "autoformat";
      desc = "Format buffer using LSP";
    }
  ];
}
