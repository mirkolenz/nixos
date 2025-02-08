{pkgs, lib, ...}:{
  programs.bat = {
    enable = true;
    extraPackages = lib.filter lib.isDerivation (lib.attrValues pkgs.bat-extras);
  };
}
