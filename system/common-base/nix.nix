{ ... }:
{
  # https://nixos.org/manual/nix/unstable/command-ref/conf-file.html#available-settings
  custom.nix.settings = {
    # https://nix.dev/manual/nix/latest/development/experimental-features
    experimental-features = [
      "flakes"
      "impure-derivations"
      "nix-command"
      "no-url-literals"
      "pipe-operators"
    ];
    nix-path = [
      "nixpkgs=flake:pkgs"
    ];
    accept-flake-config = true;
    commit-lock-file-summary = "chore(deps): update flake.lock";
    download-buffer-size = 1000000000; # 1 GB
    keep-derivations = false;
    keep-failed = false;
    keep-going = true;
    keep-outputs = true;
    log-lines = 200;
    use-xdg-base-directories = true;
    warn-dirty = false;
    # determinate nix features
    eval-cores = 0;
    lazy-trees = true;
  };
}
