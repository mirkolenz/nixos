{
  pkgs,
  stateVersionDarwin,
  ...
}: {
  imports = [
    ../common
    ./homebrew.nix
    ./settings.nix
  ];

  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;

  nix.linux-builder.enable = true;

  nix.settings.build-users-group = "nixbld";

  system.checks.verifyBuildUsers = false;
  system.stateVersion = stateVersionDarwin;
}
