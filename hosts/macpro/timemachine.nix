{ pkgs, ... }:
{
  # Samba user management is independent of the system users
  # https://www.samba.org/samba/docs/current/man-html/pdbedit.8.html
  # Add user: sudo pdbedit -a -u USER
  # Change password: sudo pdbedit -u USER
  # Delete user: sudo pdbedit -x USER
  # List users: sudo pdbedit -L
  users = {
    users.timemachine = {
      isSystemUser = true;
      uid = 510;
      group = "timemachine";
    };
    groups.timemachine.gid = 510;
  };
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
        "valid users" = "timemachine";
        "force user" = "timemachine";
        "force group" = "timemachine";
        public = "no";
        writeable = "yes";
        "fruit:time machine" = "yes";
        browseable = "yes";
        "vfs objects" = "catia fruit streams_xattr";
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
