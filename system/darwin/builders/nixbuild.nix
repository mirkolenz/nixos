{ lib, user, ... }:
{
  environment.etc."ssh/ssh_config.d/100-nixbuild.conf".text = ''
    Host nixbuild
      Hostname eu.nixbuild.net
      PubkeyAcceptedKeyTypes ssh-ed25519
      ServerAliveInterval 60
      IPQoS throughput
  '';
  nix.buildMachines = lib.singleton {
    hostName = "nixbuild";
    maxJobs = 100;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    supportedFeatures = [
      "benchmark"
      "big-parallel"
    ];
    sshKey = "/Users/${user.login}/.ssh/id_nixbuild";
    protocol = "ssh-ng";
  };
}
