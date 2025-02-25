{ ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      default_format_opts.lsp-format = "prefer";
    };
  };
}
