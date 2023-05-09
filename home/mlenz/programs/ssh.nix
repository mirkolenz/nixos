{ pkgs, lib, config, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        extraOptions = lib.mkIf pkgs.stdenv.isDarwin {
          UseKeychain = "yes";
          AddKeysToAgent = "yes";
        };
        identityFile = [ "id_ed25519" ];
      };
      wi2gpu = {
        hostname = "136.199.130.136";
        forwardAgent = true;
        user = "mlenz";
      };
      wi2v214 = {
        hostname = "v214.wi2.uni-trier.de";
        forwardAgent = true;
        user = "lenz";
      };
      homeserver = {
        hostname = "10.16.2.22";
        forwardAgent = true;
        user = "mlenz";
      };
      raspi = {
        hostname = "10.16.2.23";
        forwardAgent = true;
        user = "mlenz";
      };
      wi2docker = {
        hostname = "docker.wi2.uni-trier.de";
        user = "container";
      };
    };
  };
}
