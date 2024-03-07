{ user, ... }:
{
  # For a user to be authenticated on the samba server,
  # you must add their password using smbpasswd -a <user> as root.
  services.samba = {
    enable = true;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
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
}
