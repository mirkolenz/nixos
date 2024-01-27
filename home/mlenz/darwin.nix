{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    mas
    neovide-bin
    vimr-bin
    restic-browser-bin
  ];
  # add binaries for desktop apps to ~/bin
  # currently required for the following apps:
  # restic-browser, vim guis
  home.file."bin".source = let
    env = pkgs.buildEnv {
      name = "home-bin";
      paths = with pkgs; [
        restic
        # https://github.com/nix-community/nixvim/blob/main/wrappers/hm.nix
        config.programs.nixvim.finalPackage
      ];
      pathsToLink = ["/bin"];
    };
  in "${lib.getBin env}/bin";
  custom.texlive = {
    enable = true;
    bibFolder = "${config.home.homeDirectory}/Developer/mirkolenz/bibliography";
  };
  home.sessionVariables = {
    EDITOR = lib.mkForce "code -w";
  };
}
