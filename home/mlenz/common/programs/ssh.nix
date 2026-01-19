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
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = config.custom.profile.isDesktop;
    enableDefaultConfig = false;
    includes = lib.mkIf pkgs.stdenv.isDarwin [
      "${config.home.homeDirectory}/.orbstack/ssh/config"
    ];
    matchBlocks = {
      "*" = {
        addKeysToAgent = if pkgs.stdenv.isDarwin then "confirm" else "no";
        identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
        identityAgent = lib.mkIf pkgs.stdenv.isLinux "${config.home.homeDirectory}/.1password/agent.sock";
        extraOptions = lib.optionalAttrs pkgs.stdenv.isDarwin {
          UseKeychain = "yes";
        };
        # default config from home manager module
        forwardAgent = false;
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
      };
      "gpu" = {
        hostname = "gpu.wi2.uni-trier.de";
        forwardAgent = true;
        user = "lenz";
      };
      "kitei" = {
        hostname = "dfki-1170.dfki.uni-trier.de";
        user = "eifelkreis";
      };
      "kitei-gpu" = {
        hostname = "kitei-gpu.wi2.uni-trier.de";
        user = "compute";
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
        source = tomlFormat.generate "1password-ssh-agent.toml" {
          ssh-keys = [
            {
              vault = "Mirko";
              item = "mlenz@1password";
            }
          ];
        };
      };
}
