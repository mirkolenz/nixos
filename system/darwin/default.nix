{pkgs, ...}: {
  imports = [
    ./homebrew.nix
    ./settings.nix
  ];

  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;

  nix.linux-builder.enable = true;

  nix.settings = {
    build-users-group = "nixbld";
    # required for linux-builder
    extra-trusted-users = ["mlenz"];
  };

  system.checks.verifyBuildUsers = false;
  system.stateVersion = 4;
}
