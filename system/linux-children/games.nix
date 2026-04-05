{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcompris
    tuxpaint
    tuxtype
  ];
}
