{ lib, config, ... }:
lib.mkIf config.custom.profile.isWorkstation {
  programs.zathura = {
    enable = true;
    options = {
      synctex = true;
      synctex-editor-command = "texlab inverse-search -i %{input} -l %{line}";
    };
  };
}
