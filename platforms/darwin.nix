{ pkgs, extras, ... }:
let
  inherit (extras) unstable;
in
{
  imports = [ ./base.nix ];
  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;
  # TODO: Document that this content shall be copied from `/etc/nix/nix.conf` after running the nix-installer
  nix.extraOptions = ''
    # Generated by https://github.com/DeterminateSystems/nix-installer, version 0.5.0.
    bash-prompt-prefix = (nix:$name)\040
    extra-nix-path = nixpkgs=flake:nixpkgs
    auto-optimise-store = true
    build-users-group = nixbld
    experimental-features = nix-command flakes
  '';
  homebrew = {
    enable = false; # TODO
    global = {
      autoUpdate = true;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    taps = [
      "homebrew/core"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/bundle"
    ];
    brews = [
      # "mackup"
    ];
    casks = [
      "1password"
      "adobe-creative-cloud"
      "anydesk"
      "appcleaner"
      "arc"
      "arq"
      "balenaetcher"
      "banking-4"
      "bartender"
      "cleanshot"
      "contexts"
      "default-folder-x"
      "devonthink"
      "discord"
      "figma"
      "firefox"
      "fission"
      "fork"
      "gobdokumente"
      "google-chrome"
      "handbrake"
      "hook"
      "iina"
      "iterm2"
      "kaleidoscope"
      "kindle"
      "mediathekview"
      "mullvadvpn"
      "notion"
      "obsidian"
      "omnigraffle"
      "openinterminal"
      "orbstack"
      "orion"
      "parallels"
      "pixelsnap"
      "postico"
      "postman"
      "presentation"
      "raindropio"
      "raspberry-pi-imager"
      "raycast"
      "rectangle-process-manager"
      "replacicon"
      "shortcat"
      "soundsource"
      "steermouse"
      "tiptoi-manager"
      "utm"
      "viscosity"
      "visual-studio-code"
      "zoom"
      "zotero"
      # Fonts
      "font-eb-garamond"
      "font-fira-code"
      "font-fira-mono"
      "font-fira-sans"
      "font-firacode-nerd-font"
      "font-fontawesome"
      "font-ia-writer-duo"
      "font-ia-writer-duospace"
      "font-ia-writer-mono"
      "font-ia-writer-quattro"
      "font-ibm-plex"
      "font-iosevka"
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "font-jost"
      "font-manrope"
      "font-noto-mono"
      "font-noto-sans"
      "font-noto-sans-display"
      "font-noto-sans-math"
      "font-noto-sans-mono"
      "font-noto-sans-symbols"
      "font-noto-serif"
      "font-noto-serif-display"
      "font-roboto"
      "font-roboto-flex"
      "font-roboto-mono"
      "font-roboto-serif"
      "font-roboto-slab"
      "font-source-code-pro"
      "font-source-sans-pro"
      "font-source-serif-pro"
      "font-tangerine"
      "font-tex-gyre-adventor"
      "font-tex-gyre-bonum"
      "font-tex-gyre-bonum-math"
      "font-tex-gyre-chorus"
      "font-tex-gyre-cursor"
      "font-tex-gyre-heros"
      "font-tex-gyre-pagella"
      "font-tex-gyre-pagella-math"
      "font-tex-gyre-schola"
      "font-tex-gyre-schola-math"
      "font-tex-gyre-termes"
      "font-tex-gyre-termes-math"
      "font-ubuntu"
      "font-varela-round"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "AusweisApp2" = 948660805;
      "Baby Monitor" = 517602535;
      "Bitwarden" = 1352778147;
      "CotEditor" = 1024640650;
      "DaisyDisk" = 411643860;
      "Diagrams" = 1276248849;
      "EasyLetter" = 1495179755;
      "Final Cut Pro" = 424389933;
      "Gapplin" = 768053424;
      "GoodNotes" = 1444383602;
      "Home Assistant" = 1099568401;
      "Image2icon" = 992115977;
      "Infuse" = 1136220934;
      "iStat Menus" = 1319778037;
      "Kagi Inc." = 1622835804;
      "Keka" = 470158793;
      "Live Home 3D Pro" = 1066145115;
      "MakePass" = 1450989464;
      "Mela" = 1568924476;
      "Messenger" = 1480068668;
      "Microsoft Excel" = 462058435;
      "Microsoft Outlook" = 985367838;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;
      "Minimal Twitter" = 1668204600;
      "OneDrive" = 823766827;
      "OwlOCR" = 1499181666;
      "Pause" = 1599313358;
      "PDF Expert" = 1055273043;
      "PDFZone" = 1215383084;
      "Pixelmator Pro" = 1289583905;
      "Prime Video" = 545519333;
      "Pure Paste" = 1611378436;
      "Reeder" = 1529448980;
      "Refined GitHub" = 1519867270;
      "Save to Raindrop.io" = 1549370672;
      "ShellFish" = 1336634154;
      "SiteSucker" = 442168834;
      "Step Two" = 1448916662;
      "StopTheMadness" = 1376402589;
      "Tempus" = 1491326665;
      "TestFlight" = 899247664;
      "Todoist" = 585829637;
      "Velja" = 1607635845;
      "Vinegar" = 1591303229;
      "WireGuard" = 1451685025;
      "Yoink" = 457622435;
    };
    whalebrews = [];
  };
  environment.systemPackages = [
    pkgs.exiftool
    pkgs.fontforge
    pkgs.unpaper
    unstable._1password
    unstable.black
    unstable.buf
    # unstable.dvc # currently broken
    unstable.gomplate
    unstable.gradle
    unstable.grpcui
    unstable.home-assistant-cli
    unstable.mqttui
    unstable.nodejs
    unstable.nodePackages.prettier
    unstable.ocrmypdf
    unstable.pandoc
    unstable.plantuml
    unstable.poetry
    unstable.poetryPlugins.poetry-plugin-up
    unstable.pre-commit
    unstable.python3Full
    unstable.ruff
    unstable.speedtest-cli
    unstable.youtube-dl
    # TODO: unstable.texlive.combined.scheme-full
  ];
  security = {
    pam = {
      enableSudoTouchIdAuth = true;
    };
  };
  system = {
    stateVersion = 4;
    defaults = {
      alf = {
        globalstate = 1;
        allowsignedenabled = 1;
        allowdownloadsignedenabled = 0;
        loggingenabled = 0;
        stealthenabled = 0;
      };
      dock = {
        appswitcher-all-displays = true;
        autohide = true;
        autohide-delay = 0.24;
        autohide-time-modifier = 1.0;
        dashboard-in-overlay = false;
        enable-spring-load-actions-on-all-items = false;
        expose-animation-duration = 1.0;
        expose-group-by-app = false;
        launchanim = true;
        mineffect = "genie";
        minimize-to-application = false;
        mouse-over-hilite-stack = true;
        mru-spaces = false;
        orientation = "bottom";
        show-process-indicators = true;
        showhidden = true;
        show-recents = true;
        static-only = false;
        tilesize = 32;
        wvous-tl-corner = 1;
        wvous-bl-corner = 1;
        wvous-tr-corner = 1;
        wvous-br-corner = 1;
      };
      finder = {
        AppleShowAllFiles = false;
        ShowStatusBar = false;
        ShowPathbar = true;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "clmv";
        AppleShowAllExtensions = true;
        CreateDesktop = true;
        QuitMenuItem = false;
        _FXShowPosixPathInTitle = false;
        FXEnableExtensionChangeWarning = false;
      };
      loginwindow = {
        SHOWFULLNAME = false;
        autoLoginUser = null;
        GuestEnabled = false;
        LoginwindowText = null;
        ShutDownDisabled = false;
        SleepDisabled = false;
        RestartDisabled = false;
        ShutDownDisabledWhileLoggedIn = false;
        PowerOffDisabledWhileLoggedIn = false;
        RestartDisabledWhileLoggedIn = false;
        DisableConsoleAccess = false;
      };
      magicmouse = {
        MouseButtonMode = "TwoButton";
      };
      screencapture = {
        location = null;
        type = "png";
        disable-shadow = true;
      };
      smb = {
        NetBIOSName = null;
        ServerDescription = null;
      };
      spaces = {
        spans-displays = false;
      };
      trackpad = {
        Clicking = true;
        Dragging = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        ActuationStrength = 1;
        FirstClickThreshold = 1;
        SecondClickThreshold = 2;
      };
      universalaccess = {
        reduceTransparency = false;
        closeViewScrollWheelToggle = false;
        closeViewZoomFollowsFocus = false;
      };
      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = true;
      };
      LaunchServices = {
        LSQuarantine = true;
      };
      ".GlobalPreferences" = {
        "com.apple.sound.beep.sound" = null;
        "com.apple.mouse.scaling" = null;
      };
      NSGlobalDomain = {
        _HIHideMenuBar = false;
        "com.apple.keyboard.fnState" = false;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.springing.delay" = 1.0;
        "com.apple.springing.enabled" = null;
        "com.apple.swipescrolldirection" = true;
        "com.apple.trackpad.enableSecondaryClick" = true;
        "com.apple.trackpad.scaling" = 1.0;
        "com.apple.trackpad.trackpadCornerClickBehavior" = null;
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleEnableSwipeNavigateWithScrolls = true;
        AppleFontSmoothing = null;
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleKeyboardUIMode = null;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        AppleShowScrollBars = "WhenScrolling";
        AppleTemperatureUnit = "Celsius";
        InitialKeyRepeat = 1;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = true;
        NSDisableAutomaticTermination = null;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSScrollAnimationEnabled = true;
        NSTableViewDefaultSizeMode = 2;
        NSTextShowsControlCharacters = false;
        NSUseAnimatedFocusRing = true;
        NSWindowResizeTime = 0.020;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
      };
    };
  };
}
