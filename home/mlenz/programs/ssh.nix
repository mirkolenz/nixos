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
        hostname = "macpro.lenz.casa";
        forwardAgent = true;
        user = "mlenz";
      };
      "raspi" = {
        hostname = "raspi.lenz.casa";
        forwardAgent = true;
        user = "mlenz";
      };
      # /Users/mlenz/.orbstack/ssh/config
      "orb" = lib.mkIf pkgs.stdenv.isDarwin {
        hostname = "127.0.0.1";
        port = 32222;
        user = "default";
        identityFile = "${config.home.homeDirectory}/.orbstack/ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };
  # https://developer.1password.com/docs/ssh/agent/config
  xdg.configFile."1Password/ssh/agent.toml" =
    lib.mkIf (osConfig.programs._1password-gui.enable or false)
      {
        source = tomlFormat.generate "1password-ssh-agent" {
          ssh-keys = [
            {
              vault = "Mirko";
              item = "mlenz@1password";
            }
          ];
        };
      };
}
