{
  pkgs,
  config,
  lib,
  user,
  ...
}:
{
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/virtualisation/libvirtd.nix
  virtualisation.libvirtd = {
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      vhostUserPackages = [ pkgs.virtiofsd ];
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
      swtpm = {
        enable = true;
        package = pkgs.swtpm;
      };
    };
  };

  users.users.${user.login}.extraGroups = lib.mkIf config.virtualisation.libvirtd.enable [
    "libvirtd"
  ];

  programs.virt-manager.enable = lib.mkDefault config.custom.profile.isDesktop;

  environment.systemPackages =
    (lib.optionals config.virtualisation.libvirtd.enable [
      pkgs.dnsmasq
    ])
    ++ (lib.optionals config.custom.profile.isDesktop [
      pkgs.virt-viewer
    ]);
}
