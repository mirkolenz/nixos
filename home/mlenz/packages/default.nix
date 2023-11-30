{
  mylib,
  pkgs,
  lib,
  osConfig,
  ...
}: {
  imports = mylib.importFolder ./.;

  home.packages = with pkgs; [
    bashInteractive
    zsh
    fish
    coreutils-full
    findutils
    gnused
    gnupg
    gnupatch
    gnugrep
    gnutar
    gnumake
    inetutils
    gcc
    zip
    unzip
    lsd
    fd
    procs
    sd
    tealdeer
    bandwhich
    delta
    fzf
    rsync
    curl
    wget
    macchina
    speedtest-cli
    # bulk renaming
    massren
    mmv-go
    pipe-rename
    edir
  ];
  home.shellAliases = {
    py = "poetry run python"; # should use local poetry if possible
    cat = lib.getExe pkgs.bat;
    l = "ll";
    sudo = lib.mkIf (osConfig == {}) "sudo --preserve-env=PATH env";
  };
}
