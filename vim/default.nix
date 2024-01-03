# https://nix-community.github.io/nixvim/
{
  lib,
  specialArgs,
  moduleArgs,
  type,
}: {...}: {
  imports =
    (lib.flocken.getModules ./.)
    ++ (lib.optional lib.custom.isStable ./_stable.nix)
    ++ (lib.optional lib.custom.isUnstable ./_unstable.nix);

  config = {
    _module.args = lib.optionalAttrs (type == "standalone") moduleArgs;
    filetype.extension = {
      astro = "astro";
    };
  };
}
