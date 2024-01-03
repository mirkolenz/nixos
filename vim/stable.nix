{
  lib,
  unstableVersion,
  ...
}:
lib.optionalAttrs (lib.versionOlder lib.trivial.release unstableVersion) {}
