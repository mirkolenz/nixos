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
    icloudpd
    nixpkgs-review
    nix-output-monitor
    rlwrap
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
    py = "${lib.getExe config.programs.uv.package} run";
    cat = lib.getExe config.programs.bat.package;
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
