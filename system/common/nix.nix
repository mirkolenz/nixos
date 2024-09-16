args@{
  pkgs,
  user,
  config,
  ...
}:
{
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      !include nix.local.conf
    '';
    # https://nixos.org/manual/nix/unstable/command-ref/conf-file.html#available-settings
    settings = {
      substituters = [
        "https://mirkolenz.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "mirkolenz.cachix.org-1:R0dgCJ93t33K/gncNbKgUdJzwgsYVXeExRsZNz5jpho="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      # always-allow-substitutes = true;
      trusted-substituters = config.nix.settings.substituters;
      # https://nixos.org/manual/nix/unstable/contributing/experimental-features.html
      experimental-features = [
        "nix-command"
        "flakes"
        "impure-derivations"
        "ca-derivations"
        "repl-flake"
      ];
      max-jobs = "auto";
      keep-going = true;
      keep-outputs = true;
      keep-derivations = false;
      keep-failed = false;
      # does not build on Linux
      # plugin-files = ["${pkgs.nix-plugins}/lib/nix/plugins"];
      allowed-users = [ user.login ];
      log-lines = 25;
      builders-use-substitutes = true;
      warn-dirty = false;
      accept-flake-config = true;
      # bash-prompt-prefix = ''(nix:$name)\040'';
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    registry = import ../../registry.nix args;
    channel.enable = false;
  };
}
