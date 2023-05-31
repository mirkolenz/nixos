{pkgs, ...}: {
  imports = [
    ./homebrew.nix
    ./settings.nix
  ];

  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;

  nix.settings = {
    build-users-group = "nixbld";
  };

  environment.systemPackages = with pkgs; [
    texlive.combined.scheme-full
    tectonic
    texlab
    bibtex2cff
    bibtex-to-cff
  ];
}
