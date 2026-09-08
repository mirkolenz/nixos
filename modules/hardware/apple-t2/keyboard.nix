# Loading the t2bce modules only starts the handshake with the T2. The keyboard
# is a USB device behind the virtual host controller, and that bus enumerates
# one device every ~260ms, so it shows up around 3.5s into boot. The NVMe is
# ready at ~1.5s, which is when systemd-cryptsetup draws its passphrase prompt,
# leaving two seconds in which the prompt is visible but swallows every
# keystroke. Order the unlock after a keyboard exists instead.
{
  flake.modules.nixos.apple-t2 =
    {
      config,
      lib,
      utils,
      ...
    }:
    let
      udevadm = lib.getExe' config.boot.initrd.systemd.package "udevadm";

      # Anchoring on `cryptsetup.target` would not order anything: the unlock
      # services are only `Before` that target as well, which leaves the two
      # sides mutually unordered.
      unlockServices = map (device: "systemd-cryptsetup@${utils.escapeSystemdPath device}.service") (
        lib.attrNames config.boot.initrd.luks.devices
      );

      shutdownTargets = [
        "initrd-switch-root.target"
        "shutdown.target"
      ];
    in
    # Without an encrypted device nothing prompts this early, so the rules and
    # the extra initrd binary would just be dead weight in the installer image.
    lib.mkIf (unlockServices != [ ]) {
      # `60-input-id.rules` is not among the handful of rules NixOS puts in the
      # initrd, so the classifying builtin it would normally run is invoked here
      # to get `ID_INPUT_KEYBOARD`, and the symlink gives `udevadm wait` a fixed
      # path to block on. Matching on the classification rather than on Apple's
      # vendor id also covers an external keyboard.
      boot.initrd.services.udev.rules = ''
        SUBSYSTEM=="input", ENV{ID_INPUT}=="", IMPORT{builtin}="input_id"
        SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_KEYBOARD}=="1", SYMLINK+="input/keyboard"
      '';

      boot.initrd.systemd.storePaths = [ udevadm ];

      # One keyboard serves every device, so this is a single unit ordered ahead
      # of all of them rather than one wait per device.
      boot.initrd.systemd.services.wait-for-keyboard = {
        description = "Wait for a keyboard before unlocking the LUKS devices";
        wantedBy = unlockServices;
        before = unlockServices ++ shutdownTargets;
        conflicts = shutdownTargets;
        after = [ "systemd-udevd.service" ];
        # The unlock services run with `DefaultDependencies=no`, so a unit
        # ordered before them cannot wait on `sysinit.target` without forming a
        # cycle. Dropping the defaults only loses the shutdown ordering, which
        # the two lists above put back by hand.
        unitConfig.DefaultDependencies = false;
        # Only wanted, so a timeout still unlocks: a machine booted without a
        # usable keyboard carries on rather than stalling here forever.
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${udevadm} wait --timeout=15 /dev/input/keyboard";
        };
      };
    };
}
