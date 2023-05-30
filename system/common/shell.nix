{pkgs, ...}: {
  programs = {
    # bash is enabled by default
    fish = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
  };
  environment.shells = with pkgs; [fish];
}
