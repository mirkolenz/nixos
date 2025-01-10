{ ... }:
{
  programs.poetry = {
    enable = true;
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
