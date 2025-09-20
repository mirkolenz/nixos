{
  pkgs,
  lib,
  config,
  ...
}:
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
  home.activation = {
    uv-cache-prune = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${lib.getExe config.programs.uv.package} cache prune $VERBOSE_ARG
    '';
  };
}
