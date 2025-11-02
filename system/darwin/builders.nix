{ user, ... }:
{
  # https://github.com/LnL7/nix-darwin/blob/master/modules/nix/linux-builder.nix
  # The ServerAliveInterval and IPQoS settings have been found to make remote builds more reliable,
  # especially if there are long silent periods with no logs emitted by a build.
  custom.nix.settings.builders-use-substitutes = true;
  # https://docs.orbstack.dev/machines/ssh
  environment.etc."ssh/ssh_config.d/100-orbstack-builder.conf".text = ''
    Host orbstack-builder
      Hostname 127.0.0.1
      Port 32222
      ServerAliveInterval 60
      IPQoS throughput
  '';
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/nix-remote-build.nix
  # https://nix.dev/manual/nix/stable/command-ref/conf-file.html#conf-builders
  environment.etc."nix/machines".text = ''
    ssh-ng://nixos@orbstack-builder i686-linux,x86_64-linux,aarch64-linux /Users/${user.login}/.orbstack/ssh/id_ed25519 16 1 benchmark,big-parallel,kvm,nixos-test - -
  '';
}
