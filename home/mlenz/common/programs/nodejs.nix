{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.custom.profile.isWorkstation {
  programs.bun.enable = true;
  programs.npm = {
    enable = true;
    # https://blog.npmjs.org/post/141702881055/package-install-scripts-vulnerability
    settings = {
      prefix = "\${HOME}/.npm";
      ignore-scripts = true;
      min-release-age = 3; # days
    };
  };
  home.packages = with pkgs; [
    nodejs
    prettier
    npm-check-updates
    biome
    typescript-go
  ];
}
