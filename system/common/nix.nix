{
  user,
  config,
  inputs,
  lib',
  os,
  channel,
  ...
}:
{
  nix = {
    extraOptions = ''
      !include nix.local.conf
    '';
    # https://nixos.org/manual/nix/unstable/command-ref/conf-file.html#available-settings
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "mirkolenz.cachix.org-1:R0dgCJ93t33K/gncNbKgUdJzwgsYVXeExRsZNz5jpho="
        "pyproject-nix.cachix.org-1:UNzugsOlQIu2iOz0VyZNBQm2JSrL/kwxeCcFGw+jMe0="
        "nixbuild.net/BMAQHF-1:Q4LUtdLL0mXTO1Cs5jhcOKDZQUVlNA0u3QItwZ6uyq0="
      ];
      trusted-substituters = config.nix.settings.substituters ++ [
        "https://mirkolenz.cachix.org"
        "https://pyproject-nix.cachix.org"
        "ssh://eu.nixbuild.net"
      ];
      # https://nixos.org/manual/nix/unstable/contributing/experimental-features.html
      experimental-features = [
        "flakes"
        "impure-derivations"
        "nix-command"
        "no-url-literals"
        "pipe-operators"
      ];
      max-jobs = "auto";
      keep-going = true;
      keep-outputs = true;
      keep-derivations = false;
      keep-failed = false;
      # does not build on Linux
      # plugin-files = ["${pkgs.nix-plugins}/lib/nix/plugins"];
      allowed-users = [ user.login ];
      log-lines = 1000;
      builders-use-substitutes = true;
      warn-dirty = false;
      accept-flake-config = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    registry = lib'.self.mkRegistry { inherit inputs os channel; };
    channel.enable = false;
  };
}
