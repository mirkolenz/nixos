# https://github.com/nix-community/home-manager/blob/master/modules/misc/xdg.nix
# https://specifications.freedesktop.org/basedir/latest/
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.xdg;

  fileType =
    (import "${inputs.home-manager}/modules/lib/file-type.nix" {
      inherit (config.home) homeDirectory;
      inherit lib pkgs;
    }).fileType;

  sessionVariables = {
    # this is not part of the XDG spec
    # XDG_BIN_HOME = cfg.binHome;
  };
in
{
  options.xdg = {
    binFile = lib.mkOption {
      type = fileType "xdg.binFile" "{var}`xdg.binHome`" cfg.binHome;
      default = { };
      description = ''
        Attribute set of files to link into the user's XDG bin home.
      '';
    };

    binHome = lib.mkOption {
      type = lib.types.path;
      defaultText = "~/.local/bin";
      default = "${config.home.homeDirectory}/.local/bin";
      apply = toString;
      description = ''
        Absolute path to directory holding application binaries.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      inherit sessionVariables;
      sessionPath = [ cfg.binHome ];
      file = lib.mapAttrs' (name: file: lib.nameValuePair "${cfg.binHome}/${name}" file) cfg.binFile;
    };
    systemd.user.sessionVariables = lib.mkIf pkgs.stdenv.hostPlatform.isLinux sessionVariables;
  };
}
