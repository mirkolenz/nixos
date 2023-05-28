{ pkgs, lib, ... }:
{
  imports = [
    ./commands.nix
    ./users.nix
    ./shell.nix
    ./secrets.nix
    ../../home
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
    direnv
    nix-direnv
  ];

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };

  nix = {
    package = pkgs.nixVersions.nix_2_13; # change to nix for 23.05
    settings = {
      experimental-features = "nix-command flakes auto-allocate-uids";
      keep-going = true;
      keep-outputs = true;
      keep-derivations = true;
      keep-failed = false;
      # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
      auto-optimise-store = true;
      # https://github.com/DeterminateSystems/nix-installer/pull/270
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      # https://github.com/DeterminateSystems/nix-installer/pull/196
      auto-allocate-uids = true;
    };
    gc = lib.mkMerge [
      {
        automatic = true;
        options = "--delete-older-than 30d";
      }
      (lib.optionalAttrs (pkgs.stdenv.isLinux) {
        dates = "weekly";
      })
      (lib.optionalAttrs (pkgs.stdenv.isDarwin) {
        interval = { Weekday = 0; Hour = 0; Minute = 0; };
      })
    ];
  };
}
