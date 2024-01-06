# https://nix-community.github.io/nixvim/
{
  lib',
  specialArgs,
  moduleArgs,
}: {lib, ...}: {
  imports =
    (lib'.flocken.getModules ./.)
    ++ (lib.optional (lib'.self.isStable lib) ./_stable.nix)
    ++ (lib.optional (lib'.self.isUnstable lib) ./_unstable.nix);

  config = {
    _module.args = moduleArgs // specialArgs;
    filetype.extension = {
      astro = "astro";
    };
  };
}
