{ pkgs, ... }:
{
  # Packages
  environment.systemPackages = (with pkgs; [
    google-chrome
  ]) ++ (with pkgs.gnome; [
    nautilus
    gnome-system-monitor
    gnome-tweaks
    gnome-shell-extensions
    dconf-editor
  ]) ++ (with pkgs.gnomeExtensions; [
    dash-to-dock
    user-themes
    blur-my-shell
  ]);
  # Wayland support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "mlenz";
      };
    };
    desktopManager = {
      gnome.enable = true;
    };
    layout = "us";
    xkbVariant = "";
    excludePackages = with pkgs; [
      xterm
    ];
  };
  # Enable/disable default GNOME apps.
  services.gnome.core-utilities.enable = false;
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  # Printing
  services.printing.enable = true;
  # Enable sound with pipewire.
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
  # Gnome themes
  programs.dconf.enable = true;
}
