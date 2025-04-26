{ ... }:
{
  programs.infat = {
    enable = true;
    settings = {
      extensions = {
        md = "Zed Preview";
        pdf = "PDF Expert";
      };
      schemes = {
        mailto = "Mail";
      };
      types = {
        plain-text = "Zed Preview";
      };
    };
  };
}
