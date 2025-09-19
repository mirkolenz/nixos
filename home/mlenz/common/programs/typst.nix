{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.custom.profile.isWorkstation {
  home.packages = with pkgs; [
    typst
    typstyle
    tinymist
  ];
  home.shellAliases = {
    typc = "typst compile --root . --open skim";
    typw = "typst watch --root . --open skim";
  };
}
