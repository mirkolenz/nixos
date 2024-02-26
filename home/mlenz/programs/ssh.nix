{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
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
}
