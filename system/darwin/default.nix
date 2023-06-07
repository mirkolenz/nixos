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

  environment.systemPackages = with pkgs; [
    texlive.combined.scheme-full
    tectonic
    texlab
    bibtex2cff
    bibtex-to-cff
  ];
}
