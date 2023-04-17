{ pkgs, ... }:
{
  imports = [ ./base.nix ];
  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;
  homebrew = {
    enable = true;
    global = {
      autoUpdate = true;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };
    taps = [];
    brews = [
      "mas"
    ];
    casks = [];
    masApps = [];
    whaleBrews = [];
  };
  security = {
    pam = {
      enableSudoTouchIdAuth = true;
    };
  };
  system = {
    stateVersion = 4;
    defaults = {
      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 0.5;
      };
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "WhenScrolling";
        InitialKeyRepeat = 1;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSTableViewDefaultSizeMode = 2;
        NSWindowResizeTime = 0.001;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
      };
    };
  };
}
