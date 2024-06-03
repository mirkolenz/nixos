# https://nix-community.github.io/nixvim/
{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  config = {
    viAlias = true;
    vimAlias = true;

    # https://github.com/nix-community/nixvim/issues/1154
    # https://github.com/nix-community/nixvim/issues/1525
    enableMan = false;

    filetype.extension = {
      astro = "astro";
    };
  };
}
