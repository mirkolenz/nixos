{pkgs, ...}: {
  home.packages = with pkgs; [
    dvc
  ];
}
