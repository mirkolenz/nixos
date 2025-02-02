{ pkgs, ... }:
{
  programs.poetry = {
    enable = true;
    package = pkgs.poetry.withPlugins (
      ps: with ps; [
        poetry-plugin-up
        poetry-plugin-export
      ]
    );
    settings = {
      virtualenvs = {
        in-project = true;
        prefer-active-python = true;
        options = {
          no-pip = true;
          no-setuptools = true;
        };
      };
    };
  };
}
