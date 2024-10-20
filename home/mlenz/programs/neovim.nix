{
  pkgs,
  channel,
  ...
}:
{
  custom.neovim = {
    enable = true;
    package = pkgs."vim-${channel}";
  };
}
