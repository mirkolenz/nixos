{
  lib,
  pkgs,
  extras,
  ...
}:
lib.optionalAttrs (lib.versionOlder lib.trivial.release "23.11") {
  programs.zsh.enableSyntaxHighlighting = true;
}
