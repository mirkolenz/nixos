# https://nix-community.github.io/nixvim/
{
  lib,
  specialArgs,
  moduleArgs,
  type,
}: {...}: {
  imports =
    (lib.flocken.getModules ./.)
    ++ (lib.optional (lib.versionOlder lib.trivial.release specialArgs.unstableVersion) ./_stable.nix)
    ++ (lib.optional (lib.versionAtLeast lib.trivial.release specialArgs.unstableVersion) ./_unstable.nix);

  config = {
    _module.args = lib.optionalAttrs (type == "standalone") moduleArgs;
    filetype.extension = {
      astro = "astro";
    };
  };
}
