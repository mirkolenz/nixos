{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  home.file = {
    ".mackup.cfg" = lib.mkIf pkgs.stdenv.isDarwin { source = ./.mackup.cfg; };
    ".amethyst.yml" = lib.mkIf pkgs.stdenv.isDarwin { source = ./.amethyst.yml; };
  };
  xdg = {
    configFile = {
      "macchina/themes/custom.toml".source = ./macchina-theme.toml;
      "macchina/macchina.toml".source = ./macchina-config.toml;
      # https://developer.1password.com/docs/ssh/agent/config
      "1Password/ssh/agent.toml" =
        lib.mkIf (pkgs.stdenv.isLinux && osConfig.programs._1password-gui.enable or false)
          {
            source = tomlFormat.generate "1password-ssh-agent" {
              ssh-keys = [
                {
                  vault = "Mirko";
                  item = "Mirkos NixBook SSH Key";
                }
              ];
            };
          };
    };
  };
}
