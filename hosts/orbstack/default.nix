{ lib, config, pkgs, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
    ../../templates/workstation.nix
  ];
  networking.hostName = "orbstack";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  services.vscode-server.enable = true;

  # FROM configuration.nix
  documentation.enable = true;
  documentation.nixos.enable = true;
  environment.noXlibs = false;

  # FROM orbstack.nix
  # sudoers
  security.sudo.extraRules= [
    { users = [ "mlenz" ];
      commands = [
        { command = "ALL";
          options= [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # add OrbStack CLI tools to PATH
  environment.shellInit = ''
    . /opt/orbstack-guest/etc/profile-early

    # add your customizations here

    . /opt/orbstack-guest/etc/profile-late
  '';

  # resolv.conf: NixOS doesn't use systemd-resolved

  # faster DHCP - OrbStack uses SLAAC exclusively
  networking.dhcpcd.extraConfig = ''
    noarp
    noipv6
  '';

  # disable sshd
  services.openssh.enable = false;

  # systemd
  systemd.services."systemd-oomd".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-resolved".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-userdbd".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-udevd".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-timesyncd".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-timedated".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-portabled".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-nspawn@".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-networkd".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-machined".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-localed".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-logind".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-journald@".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-journald".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-journal-remote".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-journal-upload".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-importd".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-hostnamed".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-homed".serviceConfig.WatchdogSec = 0;

  # package installation: not needed

  # ssh config
  programs.ssh.extraConfig = ''
    Include /opt/orbstack-guest/etc/ssh_config
  '';

  # extra certificates
  security.pki.certificateFiles = [
    "/opt/orbstack-guest/run/extra-certs.crt"
  ];
}
