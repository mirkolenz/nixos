# https://nix-community.github.io/nixvim/
{
  lib,
  lib',
  ...
}: {
  imports =
    (lib'.flocken.getModules ./.)
    ++ (lib.optional (lib'.self.isStable lib.trivial.release) ./_stable.nix)
    ++ (lib.optional (lib'.self.isUnstable lib.trivial.release) ./_unstable.nix);

  config = {
    filetype.extension = {
      astro = "astro";
    };
  };
}
