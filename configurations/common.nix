{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
    };
    zsh.enable = true;
    bash.enable = true;
  };

  users.users.mlenz.shell = pkgs.fish;

  environment.systemPackages = with pkgs; [ vim ];
  environment.shells = with pkgs; [ fish ];
  environment.loginShell = pkgs.fish;

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
}
