{
  lib',
  lib,
  config,
  ...
}:
let
  # for generic linux, inject global paths into sudo PATH
  sudoPath = lib.concatStringsSep ":" [
    # add global paths
    "${config.home.profileDirectory}/bin"
    "/nix/var/nix/profiles/default/bin"
    "/nix/var/nix/profiles/default/sbin"
    # keep current paths
    "$(/usr/bin/sudo printenv PATH)"
  ];
in
{
  imports = lib'.flocken.getModules ./.;

  home.shellAliases = {
    sudo = lib.mkIf config.targets.genericLinux.enable ''/usr/bin/sudo env "PATH=${sudoPath}"'';
  };
}
