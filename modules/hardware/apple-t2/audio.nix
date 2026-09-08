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
      src = pkgs.fetchFromGitHub {
        owner = "deqrocks";
        repo = "t2bce";
        rev = "a973d53c8278e9db5ff8314b816d6880309ed39e";
        hash = "sha256-uQYwSCqp4kwPL3fYQ9mKfWe565c/O6SPpnEc7sae0x4=";
      };
      t2bceUcm = pkgs.runCommand "t2bce-alsa-ucm-conf" { } ''
        mkdir -p "$out/share/alsa"
        cp -r ${src}/t2bce_audio-alsa-ucm-conf/ucm2 "$out/share/alsa/"
      '';
      ucm2Dir = "${config.custom.apple-t2.audio.package}/share/alsa/ucm2";
      # Systemd services do not inherit environment.variables, so the audio
      # daemons have to be told about the patched configuration explicitly.
      # https://github.com/nix-community/nixos-apple-silicon/blob/66d8dd2c27f99bd5420c99938b60695aac1785c4/apple-silicon-support/modules/sound/default.nix#L46
      audioServices = lib.genAttrs [ "pipewire" "pipewire-pulse" "wireplumber" ] (_: {
        environment.ALSA_CONFIG_UCM2 = ucm2Dir;
      });
    in
    {
      # nix build .#nixosConfigurations.macbook-161.config.custom.apple-t2.audio.package
      options.custom.apple-t2.audio.package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.symlinkJoin {
          name = "alsa-ucm-conf-t2bce";
          paths = [
            pkgs.alsa-ucm-conf
            t2bceUcm
          ];
        };
        description = "ALSA UCM configuration extended with the T2 audio profiles";
      };

      config = {
        environment.variables.ALSA_CONFIG_UCM2 = ucm2Dir;

        systemd = lib.mkIf config.services.pipewire.enable {
          services = audioServices;
          user.services = audioServices;
        };
      };
    };
}
