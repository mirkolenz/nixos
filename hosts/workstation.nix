{ pkgs, ... }:
{
  # Packages
  environment.systemPackages = with pkgs; [
    google-chrome
  ];
  # Wayland support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    excludePackages = with pkgs; [
      xterm
    ];
    # Enable automatic login for the user.
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "mlenz";
  };
  # KDE Plasma 5
  services.xserver = {
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
  # GNOME
  # services.xserver = {
  #   displayManager.gdm.enable = true;
  #   desktopManager.gnome.enable = true;
  # };
  # Remove default GNOME apps.
  # services.gnome.core-utilities.enable = false;
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;
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
}
