{pkgs, ...}: {
  imports = [
    ./commands.nix
    ./darwin.nix
    ./linux.nix
    ./workstation.nix
  ];
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
    massren
    mmv
    pipe-rename
    edir
    rsync
    curl
    wget
    mkpasswd
    macchina
    speedtest-cli
  ];
  home.shellAliases = {
    py = "poetry run python"; # should use local poetry if possible
  };
}
