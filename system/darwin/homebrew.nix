{...}: {
  homebrew = {
    enable = true;
    global = {
      autoUpdate = true;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # TODO: When set to uninstall, all vscode extensions are removed
      # nix-darwin does not yet support vscode extensions in brew bundle
      # https://github.com/Homebrew/homebrew-bundle/pull/1208
      cleanup = "none";
    };
    taps = [
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
    ];
    brews = [
      "dvc"
      "envoy"
    ];
    casks = [
      "1password"
      "adobe-creative-cloud"
      "amethyst"
      "anydesk"
      "app-tamer"
      "appcleaner"
      "arc"
      "arq"
      "balenaetcher"
      # "banking-4"
      "bartender"
      "cleanshot"
      "contexts"
      "coteditor"
      "default-folder-x"
      "devonthink"
      "diffusionbee"
      "discord"
      "element"
      # "figma"
      "firefox"
      "fission"
      "fork"
      # "gobdokumente"
      "google-chrome"
      "google-drive"
      # "handbrake"
      # "hook"
      # "iina"
      "iterm2"
      # "kaleidoscope"
      # "kindle"
      "mediathekview"
      # "mullvadvpn"
      "notion"
      "obsidian"
      # "omnigraffle"
      "openinterminal"
      "orbstack"
      "orion"
      "parallels"
      "pixelsnap"
      # "postico"
      "postman"
      "presentation"
      "raindropio"
      "raycast"
      "rectangle-pro"
      # "replacicon"
      # "shortcat"
      "shottr"
      "signal"
      "skim"
      "soundsource"
      "steermouse"
      "tiptoi-manager"
      "tower"
      # "utm"
      "viscosity"
      "visual-studio-code"
      "vivaldi"
      "zed"
      "zoom"
      "zotero"
      # Fonts
      "font-big-shoulders-display"
      "font-big-shoulders-inline-text"
      "font-big-shoulders-stencil-text"
      "font-big-shoulders-inline-display"
      "font-big-shoulders-stencil-display"
      "font-big-shoulders-text"
      "font-eb-garamond"
      "font-expletus-sans"
      "font-fira-code"
      "font-fira-mono"
      "font-fira-sans"
      "font-fira-code-nerd-font"
      "font-fontawesome"
      "font-ia-writer-duo"
      # "font-ia-writer-duospace"
      "font-ia-writer-mono"
      "font-ia-writer-quattro"
      "font-ibm-plex"
      "font-iosevka"
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "font-jost"
      "font-manrope"
      # "font-noto-mono"
      # "font-noto-sans"
      # "font-noto-sans-display"
      # "font-noto-sans-math"
      # "font-noto-sans-mono"
      # "font-noto-sans-symbols"
      # "font-noto-serif"
      # "font-noto-serif-display"
      "font-overlock"
      "font-overlock-sc"
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
      "font-ubuntu-nerd-font"
      "font-ubuntu-mono"
      "font-ubuntu-mono-nerd-font"
      "font-varela-round"
    ];
    # masApps = {
    #   "1Password for Safari" = 1569813296;
    #   "AusweisApp2" = 948660805;
    #   "Bitwarden" = 1352778147;
    #   "EasyLetter" = 1495179755;
    #   "Gapplin" = 768053424;
    #   "Home Assistant" = 1099568401;
    #   # "iStat Menus" = 1319778037;
    #   "Kagi Inc." = 1622835804;
    #   "Keka" = 470158793;
    #   # "Live Home 3D Pro" = 1066145115;
    #   # "MakePass" = 1450989464;
    #   "Mela" = 1568924476;
    #   # "Messenger" = 1480068668;
    #   "Microsoft Excel" = 462058435;
    #   "Microsoft Outlook" = 985367838;
    #   "Microsoft PowerPoint" = 462062816;
    #   "Microsoft Word" = 462054704;
    #   # "Minimal Twitter" = 1668204600;
    #   "OneDrive" = 823766827;
    #   # "OwlOCR" = 1499181666;
    #   # "Pause" = 1599313358;
    #   "PDF Expert" = 1055273043;
    #   # "PDFZone" = 1215383084;
    #   # "Pixelmator Pro" = 1289583905;
    #   "Prime Video" = 545519333;
    #   "Pure Paste" = 1611378436;
    #   "Reeder" = 1529448980;
    #   # "Refined GitHub" = 1519867270;
    #   "Save to Raindrop.io" = 1549370672;
    #   "ShellFish" = 1336634154;
    #   # "SiteSucker" = 442168834;
    #   "Step Two" = 1448916662;
    #   "StopTheMadness" = 1376402589;
    #   "Tempus" = 1491326665;
    #   "TestFlight" = 899247664;
    #   "Todoist" = 585829637;
    #   # "Velja" = 1607635845;
    #   "Vinegar" = 1591303229;
    #   "WireGuard" = 1451685025;
    #   "Yoink" = 457622435;
    # };
    # whalebrews = [ ];
  };
}
