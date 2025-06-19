{ ... }:
{
  programs.infat = {
    enable = true;
    settings = {
      extensions = {
        md = "Zed";
        pdf = "PDF Expert";
      };
      schemes = {
        mailto = "Mail";
      };
      types = {
        plain-text = "Zed";
      };
    };
  };
}
