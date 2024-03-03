# https://nix-community.github.io/nixvim/
{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  config = {
    filetype.extension = {
      astro = "astro";
    };
  };
}
