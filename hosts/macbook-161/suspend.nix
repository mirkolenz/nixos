# T2 suspend workaround based on the official T2 Linux guide and
# T2Linux-Suspend-Fix (lucadibello/T2Linux-Suspend-Fix).
# Split into separate systemd services with dependency-based ordering:
# suspend/ExecStart runs leaf services first, apple-bce last;
# resume/ExecStop reverses that order automatically.
# https://wiki.t2linux.org/guides/postinstall/#suspend-workaround
# https://github.com/lucadibello/T2Linux-Suspend-Fix
#
# Not implemented: the upstream enables all ACPI S3 wake sources at boot via
# /proc/acpi/wakeup. NixOS has no declarative option for this, and the procfs
# toggle interface requires reading current state before writing (tmpfiles is
# not safe). If wake-from-suspend stops working, a boot-time oneshot service
# that parses /proc/acpi/wakeup and enables disabled S3 entries may be needed.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  modprobe = lib.getExe' pkgs.kmod "modprobe";
  rmmod = lib.getExe' pkgs.kmod "rmmod";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  systemdRun = lib.getExe' pkgs.systemd "systemd-run";
  loginctl = lib.getExe' pkgs.systemd "loginctl";
  settle = "${lib.getExe' pkgs.systemd "udevadm"} settle --timeout=15";
  jq = lib.getExe pkgs.jq;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  nmcli = lib.getExe' pkgs.networkmanager "nmcli";
  notifySend = lib.getExe' pkgs.libnotify "notify-send";
  sessionUser = "${loginctl} list-sessions --json=short | ${jq} -r '.[0].user // empty'";
  notify = message: ''
    username=$(${sessionUser})
    if [ -n "$username" ]; then
      ${systemdRun} --user --machine="$username"@.host --pipe --quiet -- \
        ${notifySend} -a "T2 Suspend" "${message}" || true
    fi
  '';
  hasIwd = config.networking.networkmanager.wifi.backend == "iwd";
  hasNm = config.networking.networkmanager.enable;
  hasTouchBar = config.hardware.apple.touchBar.enable;
  hasPipewire = config.services.pipewire.enable;
  hasThermald = config.services.thermald.enable;
  mkSuspendService = lib.recursiveUpdate {
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
in
{
  # Disable PCIe Active State Power Management to prevent suspend instability.
  boot.kernelParams = [ "pcie_aspm=off" ];

  # The official T2 suspend workaround force-unloads apple-bce with rmmod -f during suspend.
  # Enable MODULE_FORCE_UNLOAD explicitly so that workaround is supported by this kernel build.
  boot.kernelPatches = [
    {
      name = "t2-suspend-force-unload";
      patch = null;
      structuredExtraConfig = {
        MODULE_FORCE_UNLOAD = lib.kernel.yes;
      };
    }
  ];

  systemd.sleep.settings.Sleep = {
    SuspendState = "mem";
    MemorySleepMode = "deep";
  };

  systemd.services = {
    # Core: force-unloads apple-bce last on suspend, reloads first on resume.
    # All other suspend-t2-* services are ordered before this one.
    suspend-t2-apple-bce = mkSuspendService {
      description = "T2 suspend: unload/reload apple-bce";
      after = [
        "suspend-t2-wifi.service"
        "suspend-t2-audio.service"
        "suspend-t2-touchbar.service"
        "suspend-t2-backlight.service"
        "suspend-t2-thermald.service"
      ];
      serviceConfig = {
        ExecStart = [
          "-${rmmod} -f apple-bce"
        ];
        ExecStop = [
          "-${modprobe} apple-bce"
          settle
          (pkgs.writeShellScript "resume-t2-apple-bce-notify" ''
            if ! ls /sys/bus/pci/drivers/apple-bce/*:* >/dev/null 2>&1; then
              ${notify "apple-bce did not initialize within 15 s"}
            fi
          '')
        ];
      };
    };

    # Wi-Fi driver unload/reload with retry if the interface does not appear.
    # iwd does not re-detect the interface after brcmfmac reload:
    # https://github.com/NixOS/nixpkgs/issues/186274
    suspend-t2-wifi = mkSuspendService {
      description = "T2 suspend: unload/reload Wi-Fi drivers";
      serviceConfig = {
        ExecStart =
          lib.optionals hasNm [
            "-${nmcli} radio wifi off"
          ]
          ++ [
            "-${modprobe} -r brcmfmac_wcc"
            "-${modprobe} -r brcmfmac"
          ];
        ExecStop = [
          "-${modprobe} brcmfmac"
          settle
          "-${modprobe} brcmfmac_wcc"
          settle
        ]
        ++ lib.optional hasIwd "-${systemctl} restart iwd.service"
        ++ lib.optional hasNm "-${systemctl} restart NetworkManager.service"
        ++ [
          (pkgs.writeShellScript "resume-t2-wifi-retry" ''
            ${settle}
            if ! ls /sys/class/net/wl* >/dev/null 2>&1; then
              ${modprobe} -r brcmfmac || true
              ${modprobe} brcmfmac || true
              ${modprobe} brcmfmac_wcc || true
              ${settle}
              if ! ls /sys/class/net/wl* >/dev/null 2>&1; then
                ${notify "Wi-Fi interface did not appear after resume"}
              fi
            fi
          '')
        ];
      };
    };

    # Stop PipeWire before apple-bce removal to prevent kernel panic from stale PCM handles.
    suspend-t2-audio = lib.mkIf hasPipewire (mkSuspendService {
      description = "T2 suspend: stop/start PipeWire audio session";
      serviceConfig = {
        ExecStart = pkgs.writeShellScript "suspend-t2-audio" ''
          username=$(${sessionUser})
          if [ -n "$username" ]; then
            ${systemctl} --user --machine="$username"@.host stop \
              pipewire.socket pipewire-pulse.socket \
              pipewire.service pipewire-pulse.service wireplumber.service || true
          fi
        '';
        ExecStop = pkgs.writeShellScript "resume-t2-audio" ''
          username=$(${sessionUser})
          if [ -n "$username" ]; then
            ${systemctl} --user --machine="$username"@.host start \
              pipewire.socket pipewire-pulse.socket || true
          fi
        '';
      };
    });

    # Touch Bar: stop tiny-dfr and unload/reload kernel modules.
    # udevadm settle only waits for kernel/udev events, not for the DRM framebuffer
    # device to be fully initialized by appletbdrm, so tiny-dfr needs an extra delay.
    suspend-t2-touchbar = lib.mkIf hasTouchBar (mkSuspendService {
      description = "T2 suspend: unload/reload Touch Bar drivers";
      serviceConfig = {
        ExecStart = [
          "-${systemctl} stop tiny-dfr.service"
          "-${modprobe} -r appletbdrm"
          "-${modprobe} -r hid_appletb_kbd"
          "-${modprobe} -r hid_appletb_bl"
        ];
        ExecStop = [
          "-${modprobe} hid_appletb_bl"
          settle
          "-${modprobe} hid_appletb_kbd"
          settle
          "-${modprobe} appletbdrm"
          settle
          "${pkgs.coreutils}/bin/sleep 2"
          "-${systemctl} start tiny-dfr.service"
        ];
      };
    });

    # Keyboard backlight: save and dim before suspend, restore on resume.
    suspend-t2-backlight = mkSuspendService {
      description = "T2 suspend: save/restore keyboard backlight";
      serviceConfig = {
        ExecStart = "-${brightnessctl} -sd :white:kbd_backlight set 0 -q";
        ExecStop = "-${brightnessctl} -rd :white:kbd_backlight";
      };
    };

    # Fixes keyboard backlight after boot by polling for the sysfs path and
    # resetting apple-bce if it does not appear within 10 s.
    t2-kbd-backlight = {
      description = "T2 boot: fix keyboard backlight";
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "t2-kbd-backlight" ''
          ${settle}
          ${brightnessctl} -rd :white:kbd_backlight && exit 0
          ${rmmod} -f apple-bce || true
          ${modprobe} apple-bce || true
          ${settle}
          ${brightnessctl} -rd :white:kbd_backlight || true
        '';
      };
    };

    # Thermald: stop to prevent interference during suspend.
    suspend-t2-thermald = lib.mkIf hasThermald (mkSuspendService {
      description = "T2 suspend: stop/start thermald";
      serviceConfig = {
        ExecStart = "-${systemctl} stop thermald.service";
        ExecStop = "-${systemctl} start thermald.service";
      };
    });
  };
}
