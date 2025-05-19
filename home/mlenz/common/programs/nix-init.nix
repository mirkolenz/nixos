{ ... }:
{
  programs.nix-init = {
    enable = true;
    settings = {
      maintainers = [ "mirkolenz" ];
      nixpkgs = "builtins.getFlake \"nixpkgs\"";
      commit = false;
    };
  };
}
