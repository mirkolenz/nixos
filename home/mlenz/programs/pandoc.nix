{
  osConfig,
  pkgs,
  ...
}: {
  programs.pandoc = {
    enable = pkgs.stdenv.isDarwin || osConfig.services.xserver.enable;
  };
}
