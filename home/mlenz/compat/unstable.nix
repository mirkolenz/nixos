{
  lib,
  pkgs,
  unstableVersion,
  ...
}:
lib.optionalAttrs (lib.versionAtLeast lib.trivial.release unstableVersion) {}
