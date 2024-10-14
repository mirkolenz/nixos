{
  self,
  pkgs,
  channel,
  ...
}:
let
  # https://nix-community.github.io/nixvim/modules/standalone.html
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  custom.neovim = {
    enable = true;
    package = self.packages.${system}."vim-${channel}";
  };
}
