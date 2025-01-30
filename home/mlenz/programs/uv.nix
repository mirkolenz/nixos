{ pkgs, ... }:
{
  programs.uv = {
    enable = true;
    package = pkgs.uv-bin;
    # https://docs.astral.sh/uv/reference/settings/
    settings = {
      python-downloads = "manual";
      python-preference = "system";
    };
  };
}
