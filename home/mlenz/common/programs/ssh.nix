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
  home.packages = lib.mkIf (pkgs.stdenv.isLinux && (osConfig.services.openssh.enable or true)) [
    pkgs.shpool
  ];
  programs.ssh = {
    enable = config.custom.profile.isDesktop;
    addKeysToAgent = if pkgs.stdenv.isDarwin then "yes" else "no";
    includes = lib.mkIf pkgs.stdenv.isDarwin [
      "${config.home.homeDirectory}/.orbstack/ssh/config"
    ];
    matchBlocks = {
      "*" = {
        extraOptions = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.isDarwin {
            UseKeychain = "yes";
          })
          (lib.mkIf pkgs.stdenv.isLinux {
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
