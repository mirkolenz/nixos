# The browsers used on graphical Linux hosts.
#
# All three go through their home-manager module rather than a plain
# home.packages entry, because those modules are what install the native
# messaging hosts that the Vicinae browser extension needs in order to reach
# the launcher. The hosts are a no-op while the browser itself is disabled,
# since the whole config block of both modules is gated on `enable`.
{
  flake.modules.homeManager.linux =
    {
      lib,
      pkgs,
      config,
      inputs,
      ...
    }:
    lib.mkIf config.custom.features.graphical.enable {
      # programs.vicinae contributes its messaging host to firefox and
      # google-chrome on its own (enableFirefoxIntegration and
      # enableChromeIntegration), but not to Vivaldi.
      programs.vivaldi = {
        enable = true;
        # programs.vicinae.package is null, which makes the module fall back to
        # the flake's default package without exposing it, so take the input.
        nativeMessagingHosts = [ inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      };

      programs.firefox.enable = true;
      programs.google-chrome.enable = true;
    };
}
