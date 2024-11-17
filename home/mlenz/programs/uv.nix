{ pkgs, ... }:
{
  programs.uv = {
    enable = true;
    package = pkgs.uv-bin;
    settings = {
      python-downloads = "never";
      python-preference = "only-system";
    };
  };
}
