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
        ]
        ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin {
          vault = "Mirko";
          item = "mlenz@macbook";
        };
      };
    };
  };
}
