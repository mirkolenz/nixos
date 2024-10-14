# https://nix-community.github.io/nixvim/
{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  config = {
    viAlias = true;
    vimAlias = true;

    filetype.extension = {
      astro = "astro";
    };
  };
}
