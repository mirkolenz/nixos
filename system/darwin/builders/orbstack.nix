{
  lib,
  pkgs,
  user,
  ...
}:
{
  # https://docs.orbstack.dev/machines/ssh
  environment.etc."ssh/ssh_config.d/100-orbstack-builder.conf".text = ''
    Host orbstack-builder
      Hostname 127.0.0.1
      Port 32222
      ServerAliveInterval 60
      IPQoS throughput
  '';
  nix.buildMachines = lib.singleton {
    hostName = "orbstack-builder";
    speedFactor = 2;
    maxJobs = 8;
    systems = [ "${pkgs.stdenv.hostPlatform.uname.processor}-linux" ];
    supportedFeatures = [
      "kvm"
      "benchmark"
      "big-parallel"
    ];
    sshUser = "nixos";
    sshKey = "/Users/${user.login}/.orbstack/ssh/id_ed25519";
    protocol = "ssh-ng";
  };
}
