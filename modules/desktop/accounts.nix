# Online accounts and the personal-information backend behind them: GNOME Online
# Accounts owns the credentials, Evolution Data Server exposes the resulting mail,
# calendar and contact sources over D-Bus, and Stamp (modules/core/home-linux.nix)
# consumes them on every desktop.
#
# The GNOME desktop manager turns both on by itself, but Cosmic, Plasma and XFCE
# do not, which leaves Stamp without a source registry there. Only GNOME also
# ships a configuration UI (the Online Accounts panel of gnome-control-center),
# so the other desktops get the standalone XApp one instead; Plasma's own
# accounts KCM builds on signond rather than GOA and does not feed EDS.
{
  flake.modules.nixos.base =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    lib.mkIf config.custom.features.graphical.enable {
      services.gnome = {
        evolution-data-server.enable = true;
        gnome-online-accounts.enable = true;
      };

      environment.systemPackages = lib.optional (
        config.custom.features.graphical.desktopManager != "gnome"
      ) pkgs.gnome-online-accounts-gtk;
    };
}
