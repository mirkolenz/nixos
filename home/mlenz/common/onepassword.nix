{ ... }:
{
  programs.onepassword-secrets = {
    enable = false;
    tokenFile = "/etc/opnix-token";
  };
}
