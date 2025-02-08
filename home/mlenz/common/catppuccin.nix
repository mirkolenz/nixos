{ ... }:
{
  catppuccin = {
    flavor = "mocha";
    enable = true;
    # the following use import-from-derivation (IDF) which is disabled
    bottom.enable = false;
    starship.enable = false;
  };
}
