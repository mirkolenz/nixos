{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      bufdelete.enabled = true;
      debug.enabled = true;
      explorer = {
        enabled = true;
        replace_netrw = false;
      };
      git.enabled = true;
      gitbrowse.enabled = true;
      indent.enabled = true;
      input.enabled = true;
      lazygit = {
        enabled = true;
        configure = false;
      };
      notifier = {
        enabled = true;
        timeout = 5000;
      };
      picker.enabled = true;
      quickfile.enabled = true;
      rename.enabled = true;
      scope.enabled = true;
      scroll.enabled = true;
      terminal.enabled = true;
      toggle.enabled = true;
      words.enabled = true;
      zen.enabled = true;
    };
  };
}
