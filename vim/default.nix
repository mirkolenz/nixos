# https://nix-community.github.io/nixvim/
{
  lib,
  lib',
  channel,
  ...
}: {
  imports =
    (lib'.flocken.getModules ./.)
    ++ (lib.singleton ./_${channel}.nix);

  config = {
    filetype.extension = {
      astro = "astro";
    };
  };
}
