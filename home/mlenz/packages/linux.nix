{pkgs, ...}: {
  home.packages = with pkgs; [
    dvc
    mkpasswd
    macchina
    (writeShellScriptBin "nixos-env" ''
      exec ${nix}/bin/nix-env --profile /nix/var/nix/profiles/system "$@"
    '')
  ];
}
