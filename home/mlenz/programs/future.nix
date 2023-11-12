{
  lib,
  pkgs,
  extras,
  ...
}:
lib.optionalAttrs (lib.versionAtLeast lib.trivial.release "23.11") {
  programs = {
  };
}
