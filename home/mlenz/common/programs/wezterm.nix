{ config, ... }:
{
  programs.wezterm = {
    enable = config.custom.profile.isDesktop;
    extraConfig = ''
      return {
        color_scheme = "Github Dark (Gogh)",
        font = wezterm.font("Berkeley Mono"),
        font_size = 13.0,
        hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };
}
