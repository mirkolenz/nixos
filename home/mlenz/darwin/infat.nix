{ pkgs, ... }:
{
  programs.infat = {
    enable = true;
    package = pkgs.infat-bin;
    settings = {
      files = {
        md = "Zed Preview";
        pdf = "PDF Expert";
      };
      schemes = {
        mailto = "Mail";
      };
    };
  };
}
