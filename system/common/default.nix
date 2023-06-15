{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./commands.nix
    ./users.nix
    ./shell.nix
    ./secrets.nix
    ../../home
    ../cachix
  ];

  # https://zaiste.net/posts/shell-commands-rust/
  environment.systemPackages = with pkgs; [
    bat
    exa
    fd
    procs
    sd
    ripgrep
    tealdeer
    bandwhich
    delta
    fzf
    gnumake
    massren
    rsync
    curl
    wget
    gnugrep
    gnutar
    direnv
    nix-direnv
    zip
    unzip
    coreutils
    mu-repo
  ];

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      keep-going = true;
      keep-outputs = true;
      keep-derivations = true;
      keep-failed = false;
      # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
      auto-optimise-store = pkgs.stdenv.isLinux;
      # https://github.com/DeterminateSystems/nix-installer/pull/270
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      # https://github.com/DeterminateSystems/nix-installer/pull/196
      # auto-allocate-uids = true;
    };
    gc = lib.mkMerge [
      {
        automatic = true;
        options = "--delete-older-than 7d";
      }
      (lib.optionalAttrs (pkgs.stdenv.isLinux) {
        dates = "daily";
      })
      (lib.optionalAttrs (pkgs.stdenv.isDarwin) {
        interval = {
          Hour = 1;
          Minute = 0;
        };
      })
    ];
  };
}
