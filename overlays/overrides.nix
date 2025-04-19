{ ... }:
final: prev: {
  inherit (final.unstable) nixos-rebuild-ng ltex-ls-plus jujutsu;
  inherit (final.stable) php;
  mas = prev.mas.overrideAttrs (oldAttrs: rec {
    version = "2.1.0";
    src = prev.fetchurl {
      url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas-${version}.pkg";
      hash = "sha256-pT8W/ZdNP7Fv5nyTX9vKbTa2jIk3THN1HVCmuEIibfc=";
    };
  });
  inherit (final.unstable-small) codex;
}
