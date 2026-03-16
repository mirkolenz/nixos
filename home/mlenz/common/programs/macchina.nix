{ config, lib, ... }:
{
  programs.macchina = {
    enable = true;
    # https://github.com/Macchina-CLI/macchina/blob/main/macchina.toml
    settings = {
      long_uptime = false;
      long_shell = false;
      long_kernel = false;
      current_shell = true;
      physical_cores = true;
      theme = "Lithium";
    };
    # https://github.com/Macchina-CLI/macchina/tree/main/contrib/themes
    themes = lib.genAttrs [
      "Beryllium"
      "Helium"
      "Hydrogen"
      "Lithium"
    ] (name: "${config.programs.macchina.package.src}/contrib/themes/${name}.toml");
  };
}
