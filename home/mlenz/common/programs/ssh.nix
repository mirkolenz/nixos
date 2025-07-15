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
    extraConfig = ''
      IdentityFile ${config.home.homeDirectory}/.ssh/id_ed25519
      ${lib.optionalString pkgs.stdenv.isDarwin "UseKeychain yes"}
      ${lib.optionalString pkgs.stdenv.isLinux "IdentityAgent ${config.home.homeDirectory}/.1password/agent.sock"}
    '';
    matchBlocks = {
      "gpu" = {
        hostname = "gpu.wi2.uni-trier.de";
        forwardAgent = true;
        user = "lenz";
      };
      "kitei" = {
        hostname = "dfki-1170.dfki.uni-trier.de";
        forwardAgent = true;
        user = "eifelkreis";
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
