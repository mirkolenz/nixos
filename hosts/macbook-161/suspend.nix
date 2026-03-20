# https://wiki.t2linux.org/guides/postinstall/#suspend-workaround
# https://github.com/deqrocks/T2Linux-Suspend-Fix
# https://github.com/jobvisser03/jv-nix-config/blob/feature/mrsom3body-dendritic/modules/hosts/macbook-intel-nixos/_t2-suspend/default.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.hardware.apple-t2-suspend;
  modprobe = lib.getExe' pkgs.kmod "modprobe";
  rmmod = lib.getExe' pkgs.kmod "rmmod";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  loginctl = lib.getExe' pkgs.systemd "loginctl";
  udevadm = lib.getExe' pkgs.systemd "udevadm";
  jq = lib.getExe pkgs.jq;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  rfkill = lib.getExe' pkgs.util-linux "rfkill";

  hasNm = config.networking.networkmanager.enable;
  hasTouchBar = config.hardware.apple.touchBar.enable;
  hasPipewire = config.services.pipewire.enable;
  hasThermald = config.services.thermald.enable;
  hasRadio = config.hardware.apple-t2.firmware.enable || config.hardware.apple-t2-firmware.enable;
  hasIwd = config.networking.wireless.iwd.enable;
  hasBt = config.hardware.bluetooth.enable;

  forEachUser = body: ''
    for username in $(${loginctl} list-users --json=short | ${jq} -r '.[].user'); do
      ${body}
    done
  '';
  mkExecScript =
    name: body:
    pkgs.writeShellScript name ''
      set +e
      ${body}
    '';
  mkSuspendService = lib.recursiveUpdate {
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = 30;
      TimeoutStopSec = 60;
    };
  };
in
{
  options.hardware.apple-t2-suspend = {
    enable = lib.mkEnableOption "T2 Mac suspend/resume fixes";
  };

  config = lib.mkIf cfg.enable {
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
      # pm_async=0 disables asynchronous device power management during suspend/resume
      # to prevent race conditions between driver teardown and hardware state changes.
      suspend-t2-apple-bce = mkSuspendService {
        description = "T2 suspend: unload/reload apple-bce";
        after =
          [ ]
          ++ lib.optional hasRadio "suspend-t2-radio.service"
          ++ lib.optional hasPipewire "suspend-t2-audio.service"
          ++ lib.optional hasTouchBar "suspend-t2-touchbar.service"
          ++ lib.singleton "suspend-t2-backlight.service"
          ++ lib.optional hasThermald "suspend-t2-thermald.service";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-apple-bce" ''
            # Resolve the T2 PCI device before unloading the driver.
            pci_dev=$(readlink -f /sys/bus/pci/drivers/apple-bce/0000:*/. 2>/dev/null | head -1)

            ${rmmod} -f apple-bce

            # Remove the T2 PCI device so it gets fully re-enumerated on resume,
            # including a fresh DRM channel initialization for the Touch Bar.
            if [ -n "$pci_dev" ] && [ -e "$pci_dev/remove" ]; then
              echo 1 > "$pci_dev/remove"
            fi

            echo 0 > /sys/power/pm_async
          '';
          ExecStop = mkExecScript "resume-t2-apple-bce" ''
            echo 1 > /sys/power/pm_async

            # Rescan PCI bus to re-enumerate the T2 chip fresh.
            echo 1 > /sys/bus/pci/rescan
            ${udevadm} settle --timeout=15

            ${modprobe} apple-bce
            ${udevadm} settle --timeout=15
            if ! ls /sys/bus/pci/drivers/apple-bce/0000:* >/dev/null 2>&1; then
              echo "WARNING: apple-bce did not bind to a PCI device"
            fi
          '';
        };
      };

      # Wi-Fi/Bluetooth: stop services, block radios, unload/reload drivers.
      # The Broadcom PCIe device (WiFi+BT) enters D3cold during suspend and
      # cannot transition back to D0 after apple-bce force-unload. Removing it
      # from the PCI bus during suspend and rescanning on resume forces a fresh
      # enumeration in D0.
      suspend-t2-radio = lib.mkIf hasRadio (mkSuspendService {
        description = "T2 suspend: block/unblock radios and reload drivers";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-radio" ''
            # Resolve the PCIe device backing wlan0 before tearing anything down.
            pci_dev=$(readlink -f /sys/class/net/wlan0/device 2>/dev/null)

            ${lib.optionalString hasNm "${systemctl} stop NetworkManager.service"}
            ${lib.optionalString hasIwd "${systemctl} stop iwd.service"}
            ${lib.optionalString hasBt "${systemctl} stop bluetooth.service"}
            ${rfkill} block wifi
            ${rfkill} block bluetooth
            ${modprobe} -r brcmfmac_wcc
            ${modprobe} -r brcmfmac
            ${modprobe} -r brcmutil
            ${modprobe} -r hci_bcm4377
            # Remove the Broadcom PCIe device so the PCI core does not try to
            # restore a stale D3cold device on resume.
            if [ -n "$pci_dev" ] && [ -e "$pci_dev/remove" ]; then
              echo 1 > "$pci_dev/remove"
            fi
          '';
          ExecStop = mkExecScript "resume-t2-radio" ''
            # Rescan PCI bus to re-enumerate the Broadcom chip in D0.
            echo 1 > /sys/bus/pci/rescan
            ${udevadm} settle --timeout=15
            ${modprobe} brcmutil
            ${modprobe} brcmfmac
            ${udevadm} settle --timeout=15
            ${modprobe} brcmfmac_wcc
            ${modprobe} hci_bcm4377
            # brcmfmac loads firmware in-kernel (invisible to udev settle).
            # Wait for the network interface to appear instead.
            if ! ${udevadm} wait --timeout=15 /sys/class/net/wlan0; then
              echo "WARNING: Wi-Fi interface did not appear within 15 s"
            fi
            ${rfkill} unblock wifi
            ${rfkill} unblock bluetooth
            ${lib.optionalString hasBt "${systemctl} start bluetooth.service"}
            ${lib.optionalString hasIwd "${systemctl} start iwd.service"}
            ${lib.optionalString hasNm "${systemctl} start NetworkManager.service"}
          '';
        };
      });

      # Stop PipeWire before apple-bce removal to prevent kernel panic from stale PCM handles.
      suspend-t2-audio = lib.mkIf hasPipewire (mkSuspendService {
        description = "T2 suspend: stop/start PipeWire audio session";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-audio" (forEachUser ''
            ${systemctl} --user --machine="$username"@.host stop \
              pipewire.socket pipewire-pulse.socket \
              pipewire.service pipewire-pulse.service wireplumber.service
          '');
          ExecStop = mkExecScript "resume-t2-audio" (forEachUser ''
            ${systemctl} --user --machine="$username"@.host start \
              pipewire.socket pipewire-pulse.socket
          '');
        };
      });

      # appletbdrm probe requires the T2 DRM channel to be fully initialized.
      # At boot this happens naturally (~40 s after apple-bce). On resume the
      # channel needs time, so this service retries via Restart=on-failure.
      # The last command (systemctl start tiny-dfr) determines the exit code:
      # it fails while the DRM device is absent, triggering a retry.
      t2-appletbdrm = lib.mkIf hasTouchBar {
        description = "T2: load appletbdrm and start tiny-dfr";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = mkExecScript "load-t2-appletbdrm" ''
            ${modprobe} -r appletbdrm 2>/dev/null
            ${modprobe} appletbdrm
            ${udevadm} settle --timeout=10
            # Check device unit directly — systemctl start tiny-dfr would block
            # indefinitely waiting for its BindsTo/After device dependencies.
            # tiny-dfr also depends on dev-tiny_dfr_backlight (hid_appletb_bl,
            # loaded earlier) and dev-tiny_dfr_display_backlight (gmux, always
            # present). Only the display device from appletbdrm needs retries.
            ${systemctl} is-active --quiet dev-tiny_dfr_display.device || exit 1
            ${systemctl} start tiny-dfr.service
          '';
          Restart = "on-failure";
          RestartSec = "5s";
          StartLimitIntervalSec = 180;
          StartLimitBurst = 30;
        };
      };

      # Touch Bar: stop tiny-dfr and unload/reload kernel modules.
      suspend-t2-touchbar = lib.mkIf hasTouchBar (mkSuspendService {
        description = "T2 suspend: unload/reload Touch Bar drivers";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-touchbar" ''
            ${systemctl} stop tiny-dfr.service
            ${systemctl} stop t2-appletbdrm.service 2>/dev/null || true
            ${modprobe} -r hid_appletb_kbd
            ${modprobe} -r hid_appletb_bl
            ${modprobe} -r appletbdrm
          '';
          ExecStop = mkExecScript "resume-t2-touchbar" ''
            ${modprobe} hid_appletb_bl
            if ! ${udevadm} wait --timeout=15 /sys/class/leds/:white:kbd_backlight; then
              echo "WARNING: kbd_backlight LED device did not appear within 15 s"
            fi

            ${modprobe} hid_appletb_kbd
            ${udevadm} settle --timeout=15

            # Kick off appletbdrm retry service in the background.
            # It retries until the T2 DRM channel is ready, then starts tiny-dfr.
            ${systemctl} reset-failed t2-appletbdrm.service 2>/dev/null || true
            ${systemctl} start --no-block t2-appletbdrm.service
          '';
        };
      });

      # Keyboard backlight: save and dim before suspend, restore on resume.
      suspend-t2-backlight = mkSuspendService {
        description = "T2 suspend: save/restore keyboard backlight";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-backlight" ''
            ${brightnessctl} -sd :white:kbd_backlight set 0 -q
          '';
          ExecStop = mkExecScript "resume-t2-backlight" ''
            ${brightnessctl} -rd :white:kbd_backlight
          '';
        };
      };

      # Sets keyboard backlight on boot.
      t2-kbd-backlight = {
        description = "T2 boot: set keyboard backlight";
        wantedBy = [ "multi-user.target" ];
        after = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = mkExecScript "t2-kbd-backlight" ''
            ${brightnessctl} -d :white:kbd_backlight set 50% -q
          '';
        };
      };

      # Thermald: stop to prevent interference during suspend.
      suspend-t2-thermald = lib.mkIf hasThermald (mkSuspendService {
        description = "T2 suspend: stop/start thermald";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-thermald" ''
            ${systemctl} stop thermald.service
          '';
          ExecStop = mkExecScript "resume-t2-thermald" ''
            ${systemctl} start thermald.service
          '';
        };
      });
    };
  };
}
