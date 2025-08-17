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
    zsh
    fish
    moreutils
    gnupg
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
    wget
    ookla-speedtest
    restic
    autorestic
    sqlite
    icloudpd
    nixpkgs-review
    nix-output-monitor
    rlwrap
    wol
    # json parsing
    jq
    jaq
    jql
    yq
    dasel
    # bulk renaming
    massren
    mmv-go
    pipe-rename
    edir
    # disk usage
    gdu
    dua
    ncdu
    duf
    # required packages: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/system-path.nix
    # acl # not available on darwin
    # attr # not available on darwin
    bashInteractive # bash with ncurses support
    bzip2
    coreutils-full
    cpio
    curl
    diffutils
    findutils
    gawk
    stdenv.cc.libc
    getent
    getconf
    gnugrep
    gnused
    gzip
    xz
    less
    # libcap # not available on darwin
    ncurses
    netcat
    mkpasswd
    procps
    # su # not available on darwin
    time
    util-linux
    which
    zstd
  ];
  home.shellAliases = {
    cat = lib.getExe config.programs.bat.package;
    lg = lib.getExe config.programs.lazygit.package;
    l = "ll";
    dc = "docker compose";
    py = "${lib.getExe' config.programs.uv.package "uv"} run";
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
