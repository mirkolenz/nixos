{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        extraOptions = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.isDarwin {
            UseKeychain = "yes";
            AddKeysToAgent = "yes";
          })
          (lib.mkIf (pkgs.stdenv.isLinux && (osConfig.services.xserver.enable or false)) {
            IdentityAgent = "${config.home.homeDirectory}/.1password/agent.sock";
          })
        ];
        identityFile = lib.mkIf pkgs.stdenv.isDarwin [ "id_ed25519" ];
      };
      "wi2gpu" = {
        hostname = "gpu.wi2.uni-trier.de";
        forwardAgent = true;
        user = "lenz";
      };
      "macpro homeserver" = {
        hostname = "10.16.2.22";
        forwardAgent = true;
        user = "mlenz";
      };
      "raspi" = {
        hostname = "10.16.2.23";
        forwardAgent = true;
        user = "mlenz";
      };
    };
  };
  # https://github.com/nix-community/home-manager/issues/322#issuecomment-1856128020
  # home.file.".ssh/config" = {
  #   target = ".ssh/config_source";
  #   onChange = ''
  #     cp -f ${config.home.homeDirectory}/.ssh/config_source ${config.home.homeDirectory}/.ssh/config
  #     chmod 400 ${config.home.homeDirectory}/.ssh/config
  #   '';
  # };
  # https://developer.1password.com/docs/ssh/agent/config
  xdg.configFile."1Password/ssh/agent.toml" =
    lib.mkIf (osConfig.programs._1password-gui.enable or false)
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
}
