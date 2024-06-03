{ user, pkgs, ... }:
{
  # https://github.com/LnL7/nix-darwin/blob/master/modules/nix/linux-builder.nix
  # https://docs.orbstack.dev/machines/ssh
  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
    buildMachines = [
      {
        hostName = "nixos@orb";
        sshUser = "mlenz";
        # sshKey = "/Users/${user.login}/.orbstack/ssh/id_ed25519";
        # publicHostKey = null;
        maxJobs = 4;
        protocol = "ssh-ng";
        supportedFeatures = [
          "kvm"
          "benchmark"
          "big-parallel"
        ];
        systems = [ "${pkgs.stdenv.hostPlatform.uname.processor}-linux" ];
      }
    ];
  };
}
