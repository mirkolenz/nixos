# Speaker/microphone support for the t2bce audio driver.
# The driver exposes a plain ALSA device, so the profiles shipped by t2bce are
# merged into the default ALSA UCM configuration.
# https://github.com/deqrocks/t2bce/tree/main/t2bce_audio-alsa-ucm-conf
{
  flake.modules.nixos.apple-t2 =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      ucm2Dir = "${config.custom.apple-t2.audio.package}/share/alsa/ucm2";
      # Systemd services do not inherit environment.variables, so the audio
      # daemons have to be told about the patched configuration explicitly.
      # https://github.com/nix-community/nixos-apple-silicon/blob/66d8dd2c27f99bd5420c99938b60695aac1785c4/apple-silicon-support/modules/sound/default.nix#L46
      audioServices = lib.genAttrs [ "pipewire" "pipewire-pulse" "wireplumber" ] (_: {
        environment.ALSA_CONFIG_UCM2 = ucm2Dir;
      });
    in
    {
      # nix build .#packages.x86_64-linux.alsa-ucm-conf-t2bce
      options.custom.apple-t2.audio.package = lib.mkPackageOption pkgs "alsa-ucm-conf-t2bce" { };

      config = {
        environment.variables.ALSA_CONFIG_UCM2 = ucm2Dir;

        systemd = lib.mkIf config.services.pipewire.enable {
          services = audioServices;
          user.services = audioServices;
        };
      };
    };
}
