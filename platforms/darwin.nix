{ pkgs, extras, ... }:
let
  inherit (extras) unstable;
in
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
      "1Password for Safari" = 1569813296
      "AusweisApp2" = 948660805
      "Baby Monitor" = 517602535
      "Bitwarden" = 1352778147
      "CotEditor" = 1024640650
      "DaisyDisk" = 411643860
      "Diagrams" = 1276248849
      "EasyLetter" = 1495179755
      "Final Cut Pro" = 424389933
      "Gapplin" = 768053424
      "GoodNotes" = 1444383602
      "Home Assistant" = 1099568401
      "Image2icon" = 992115977
      "Infuse" = 1136220934
      "iStat Menus" = 1319778037
      "Kagi Inc." = 1622835804
      "Keka" = 470158793
      "Live Home 3D Pro" = 1066145115
      "MakePass" = 1450989464
      "Mela" = 1568924476
      "Messenger" = 1480068668
      "Microsoft Excel" = 462058435
      "Microsoft Outlook" = 985367838
      "Microsoft PowerPoint" = 462062816
      "Microsoft Word" = 462054704
      "Minimal Twitter" = 1668204600
      "OneDrive" = 823766827
      "OwlOCR" = 1499181666
      "Pause" = 1599313358
      "PDF Expert" = 1055273043
      "PDFZone" = 1215383084
      "Pixelmator Pro" = 1289583905
      "Prime Video" = 545519333
      "Pure Paste" = 1611378436
      "Reeder" = 1529448980
      "Refined GitHub" = 1519867270
      "Save to Raindrop.io" = 1549370672
      "ShellFish" = 1336634154
      "SiteSucker" = 442168834
      "Step Two" = 1448916662
      "StopTheMadness" = 1376402589
      "Tempus" = 1491326665
      "TestFlight" = 899247664
      "Todoist" = 585829637
      "Velja" = 1607635845
      "Vinegar" = 1591303229
      "WireGuard" = 1451685025
      "Yoink" = 457622435
    };
    whaleBrews = [];
  };
  environment.systemPackages = [
    pkgs.black
    pkgs.dvc
    pkgs.exiftool
    pkgs.fontforge
    pkgs.gomplate
    pkgs.gradle
    pkgs.grpcui
    pkgs.home-assistant-cli
    pkgs.latexindent
    pkgs.mqttui
    pkgs.ocrmypdf
    pkgs.pandoc
    pkgs.plantuml
    pkgs.pre-commit
    pkgs.prettier
    pkgs.ruff
    pkgs.speedtest-cli
    pkgs.unpaper
    unstable._1password
    unstable.buf
    unstable.nodejs
    unstable.poetry
    unstable.poetryPlugins.poetry-plugin-up
    unstable.python3Full
    unstable.texlive.combined.scheme-full
    unstable.youtube-dl
  ];
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
