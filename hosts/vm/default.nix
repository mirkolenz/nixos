{pkgs,...}:
{
  imports = [ ./hardware-qemu.nix ../server.nix ];
  networking.hostName = "nixos-vm";
  services.vscode-server.enable = true;
  # Packages
  environment.systemPackages = with pkgs; [
    google-chrome
  ];
  # Wayland support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    layout = "us";
    xkbVariant = "";
    excludePackages = with pkgs; [
      xterm
    ];
    # Enable automatic login for the user.
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "mlenz";
  };
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
  # Parallels
  # boot.loader.grub = {
  #   enable = true;
  #   device = "/dev/sda";
  # };
  # QEMU
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/efi";
      canTouchEfiVariables = true;
    };
    systemd-boot.enable = true;
  };
}
