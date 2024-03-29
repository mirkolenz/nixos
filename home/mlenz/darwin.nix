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
  home.file."bin".source =
    let
      binaries = {
        restic = pkgs.restic;
        # https://github.com/nix-community/nixvim/blob/main/wrappers/hm.nix
        nvim = config.programs.nixvim.finalPackage;
      };
      symbolicLinks = lib.mapAttrsToList (name: path: ''
        ln -s "${lib.getBin path}/bin/${name}" "$out/${name}"
      '') binaries;
    in
    pkgs.runCommand "home-bin" { } ''
      mkdir -p "$out"
      ${lib.concatLines symbolicLinks}
    '';
  custom.texlive = {
    enable = true;
    # causes `too many open files`
    # packageConfig = {
    #   withDocs = true;
    # };
    bibFolder = "${config.home.homeDirectory}/Developer/mirkolenz/bibliography";
  };
  home.sessionVariables = {
    EDITOR = lib.mkForce "code -w";
  };
}
