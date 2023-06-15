{pkgs, ...}: {
  home.packages = with pkgs; [
    mkpasswd
    macchina
    (writeShellScriptBin "nixos-env" ''
      exec ${nix}/bin/nix-env --profile /nix/var/nix/profiles/system "$@"
    '')
  ];
}
