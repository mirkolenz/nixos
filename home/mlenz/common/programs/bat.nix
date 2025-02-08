{pkgs, lib, ...}:{
  programs.bat = {
    enable = true;
    extraPackages = lib.attrValues pkgs.bat-extras;
  };
}
