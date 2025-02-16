{ ... }:
{
  plugins.telescope = {
    enable = true;
    extensions = {
      file-browser = {
        enable = true;
        settings = {
          hijack_netrw = true;
        };
      };
      frecency.enable = true;
      fzf-native.enable = true;
      live-grep-args.enable = true;
      media-files.enable = true;
      project.enable = true;
    };
  };
}
