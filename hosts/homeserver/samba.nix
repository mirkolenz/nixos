{ ... }:
{
  # For a user to be authenticated on the samba server,
  # you must add their password using smbpasswd -a <user> as root.
  services.samba = {
    enable = true;
    # openFirewall = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = homesamba
      netbios name = homesamba
      security = user
      hosts allow = 10.16.0.1/16 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      tm_share = {
        path = "/mnt/Shares/tm_share";
        "valid users" = "username";
        public = "no";
        writeable = "yes";
        "force user" = "username";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
      # public = {
      #   path = "/mnt/Shares/Public";
      #   browseable = "yes";
      #   "read only" = "no";
      #   "guest ok" = "yes";
      #   "create mask" = "0644";
      #   "directory mask" = "0755";
      #   "force user" = "username";
      #   "force group" = "groupname";
      # };
      # private = {
      #   path = "/mnt/Shares/Private";
      #   browseable = "yes";
      #   "read only" = "no";
      #   "guest ok" = "no";
      #   "create mask" = "0644";
      #   "directory mask" = "0755";
      #   "force user" = "username";
      #   "force group" = "groupname";
      # };
    };
  };
}
