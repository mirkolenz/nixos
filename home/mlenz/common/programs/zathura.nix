{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.custom.profile.isWorkstation {
  programs.zathura = {
    enable = true;
    options = {
      synctex = true;
      synctex-editor-command = "texlab inverse-search -i %{input} -l %{line}";
    };
  };
  xdg.configFile = {
    "zathura/flexoki-dark".source = "${pkgs.flexoki}/share/zathura/flexoki-dark";
    "zathura/flexoki-light".source = "${pkgs.flexoki}/share/zathura/flexoki-light";
  };
}
