{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.custom.features.withOptionals {
  home.packages = with pkgs; [
    php
    phpstan
    phpactor
    pretty-php
    frankenphp
    phpPackages.php-cs-fixer
    phpPackages.php-parallel-lint
  ];
}
