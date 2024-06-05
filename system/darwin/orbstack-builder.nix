{ user, pkgs, ... }:
{
  # https://github.com/LnL7/nix-darwin/blob/master/modules/nix/linux-builder.nix
  # https://docs.orbstack.dev/machines/ssh
  environment.etc."ssh/ssh_config.d/100-orbstack-builder.conf".text = ''
    Host orbstack-builder
      Hostname 127.0.0.1
      Port 32222
  '';
  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
    buildMachines = [
      {
        hostName = "orbstack-builder";
        sshUser = "nixos";
        sshKey = "/Users/${user.login}/.orbstack/ssh/id_ed25519";
        # sudo ssh nixos@orbstack-builder
        publicHostKey = null;
        maxJobs = 4;
        protocol = "ssh";
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
