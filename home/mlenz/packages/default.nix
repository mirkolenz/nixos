{
  pkgs,
  lib,
  lib',
  osConfig,
  config,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  home.packages = with pkgs; [
    bashInteractive
    zsh
    fish
    coreutils-full
    procps
    gawk
    moreutils
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
    ookla-speedtest
    restic
    autorestic
    sqlite
    mkpasswd
    # json parsing
    jaq
    jq
    jql
    yq
    dasel
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
    sudo =
      let
        customPaths = [
          "${config.home.homeDirectory}/.nix-profile/bin"
          "/nix/var/nix/profiles/default/bin"
          "/nix/var/nix/profiles/default/sbin"
        ];
      in
      lib.mkIf (osConfig == { })
        ''/usr/bin/sudo env "PATH=${lib.concatStringsSep ":" customPaths}:$(/usr/bin/sudo printenv PATH)"'';
  };
}
