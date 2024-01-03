{
  lib,
  unstableVersion,
  ...
}:
lib.optionalAttrs (lib.versionAtLeast lib.trivial.release unstableVersion) {
  plugins.lsp.servers.dockerls.enable = true;
}
