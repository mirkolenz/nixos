{ config, ... }:
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
    themes = {
      Lithium = "${config.programs.macchina.package.src}/contrib/themes/Lithium.toml";
    };
  };
}
