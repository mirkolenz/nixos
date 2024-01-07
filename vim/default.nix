# https://nix-community.github.io/nixvim/
{
  lib,
  lib',
  ...
}: {
  imports =
    (lib'.flocken.getModules ./.)
    ++ (lib.optional (lib'.self.isStable lib) ./_stable.nix)
    ++ (lib.optional (lib'.self.isUnstable lib) ./_unstable.nix);

  config = {
    filetype.extension = {
      astro = "astro";
    };
  };
}
