{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.custom.features.withDisplay {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = lib.mkIf pkgs.stdenv.isDarwin [
      "${config.home.homeDirectory}/.orbstack/ssh/config"
    ];
    matchBlocks = {
      "*" = {
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
        hostname = "kitei-gpu.wi2.uni-trier.de";
        user = "compute";
      };
      "raise" = {
        hostname = "raise.dfki.de";
        forwardAgent = true;
        user = "mlenz";
      };
      "macpro homeserver" = {
        hostname = "macpro.taildc4a8b.ts.net";
        forwardAgent = true;
        user = "mlenz";
      };
      "raspi" = {
        hostname = "raspi.taildc4a8b.ts.net";
        forwardAgent = true;
        user = "mlenz";
      };
    };
  };
}
