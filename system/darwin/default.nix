{pkgs, ...}: {
  imports = [
    ./homebrew.nix
    ./settings.nix
  ];

  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;

  nix.settings = {
    build-users-group = "nixbld";
    # required for linux-builder
    extra-trusted-users = ["mlenz"];
  };

  system.checks.verifyBuildUsers = false;

  # https://github.com/LnL7/nix-darwin/issues/701
  # documentation.enable = false;
}
