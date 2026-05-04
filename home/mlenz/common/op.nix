{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.custom.features.withDisplay {
  programs.op = {
    enable = true;
    sshAgent = {
      enable = true;
      settings = {
        ssh-keys = [
          {
            vault = "Mirko";
            item = "mlenz@1password";
          }
          {
            vault = "Mirko";
            item = "mlenz@git";
          }
        ]
        ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin {
          vault = "Mirko";
          item = "mlenz@macbook";
        };
      };
    };
    gitSign = {
      enable = false;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdqY/FHF8Q2QGhE84GswFe6r1g4+nCPR+yTGaStVi4Q mlenz@git";
    };
  };
}
