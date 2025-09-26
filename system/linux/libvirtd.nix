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

  environment.etc = lib.mkIf config.virtualisation.libvirtd.enable (
    (lib.genAttrs'
      [
        "edk2-aarch64-code.fd"
        "edk2-arm-code.fd"
        "edk2-arm-vars.fd"
        "edk2-i386-code.fd"
        "edk2-i386-secure-code.fd"
        "edk2-i386-vars.fd"
        "edk2-loongarch64-code.fd"
        "edk2-loongarch64-vars.fd"
        "edk2-riscv-code.fd"
        "edk2-riscv-vars.fd"
        "edk2-x86_64-code.fd"
        "edk2-x86_64-secure-code.fd"
      ]
      (name: {
        name = "nix-libvirtd/qemu/${name}";
        value = {
          source = "${config.virtualisation.libvirtd.qemu.package}/share/qemu/${name}";
        };
      })
    )
    // {
      "nix-libvirtd/images/virtio-win.iso".source = pkgs.virtio-win.src;
    }
  );
}
