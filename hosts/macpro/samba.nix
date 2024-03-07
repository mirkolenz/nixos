{ user, pkgs, ... }:
{
  # For a user to be authenticated on the samba server,
  # you must add their password using smbpasswd -a <user> as root.
  # https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6
  services.samba = {
    enable = true;
    package = pkgs.samba4Full;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      server smb encrypt = required
      server string = homeserver
      hosts allow = 10.16.0.1/16 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
      fruit:aapl = yes
      fruit:model = MacPro
      fruit:advertise_fullsync = true
    '';
    shares = {
      timemachine = {
        path = "/mnt/backup/timemachine";
        "valid users" = user.login;
        public = "no";
        writeable = "yes";
        "fruit:time machine" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        browseable = "yes";
      };
    };
  };
  # for windows network discovery
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
  # for mac network discovery
  services.avahi = {
    enable = true;
    openFirewall = true;
    publish.enable = true;
    publish.userServices = true;
  };
}
