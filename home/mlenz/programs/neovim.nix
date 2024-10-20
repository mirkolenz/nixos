{
  pkgs,
  channel,
  ...
}:
{
  custom.neovim = {
    enable = true;
    package = pkgs."nixvim-${channel}";
  };
}
