{ ... }:
{
  homebrew = {
    enable = true;
    global = {
      autoUpdate = true;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # When set to uninstall, all vscode extensions are removed
      # nix-darwin does not yet support vscode extensions in brew bundle
      # https://github.com/Homebrew/homebrew-bundle/pull/1208
      cleanup = "none";
    };
    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
    ];
    brews = [ ];
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
      "bartender"
      "betterdisplay"
      "cleanshot"
      "contexts"
      "coteditor"
      "dadroit-json-viewer"
      "default-folder-x"
      "devonthink"
      "discord"
      "element"
      "figma"
      "firefox"
      "fission"
      "font-big-shoulders-display"
      "font-big-shoulders-inline-display"
      "font-big-shoulders-inline-text"
      "font-big-shoulders-stencil-display"
      "font-big-shoulders-stencil-text"
      "font-big-shoulders-text"
      "font-eb-garamond"
      "font-expletus-sans"
      "font-fira-code-nerd-font"
      "font-fira-code"
      "font-fira-mono"
      "font-fira-sans"
      "font-fontawesome"
      "font-geist-mono"
      "font-geist"
      "font-ia-writer-duo"
      "font-ia-writer-mono"
      "font-ia-writer-quattro"
      "font-ibm-plex"
      "font-inter"
      "font-iosevka"
      "font-jetbrains-mono-nerd-font"
      "font-jetbrains-mono"
      "font-jost"
      "font-manrope"
      "font-monaspace"
      "font-overlock-sc"
      "font-overlock"
      "font-roboto-flex"
      "font-roboto-mono"
      "font-roboto-serif"
      "font-roboto-slab"
      "font-roboto"
      "font-source-code-pro"
      "font-source-sans-3"
      "font-source-serif-4"
      "font-tangerine"
      "font-tex-gyre-adventor"
      "font-tex-gyre-bonum-math"
      "font-tex-gyre-bonum"
      "font-tex-gyre-chorus"
      "font-tex-gyre-cursor"
      "font-tex-gyre-heros"
      "font-tex-gyre-pagella-math"
      "font-tex-gyre-pagella"
      "font-tex-gyre-schola-math"
      "font-tex-gyre-schola"
      "font-tex-gyre-termes-math"
      "font-tex-gyre-termes"
      "font-ubuntu-mono-nerd-font"
      "font-ubuntu-mono"
      "font-ubuntu-nerd-font"
      "font-ubuntu"
      "font-varela-round"
      "fork"
      "forklift"
      "google-chrome"
      "google-drive"
      "handbrake"
      "ia-presenter"
      "iterm2"
      "mediathekview"
      "microsoft-teams"
      "notion"
      "obsidian"
      "omnigraffle"
      "openinterminal"
      "orbstack"
      "orion"
      "parallels"
      "pixelsnap"
      "postman"
      "presentation"
      "raindropio"
      "raycast"
      "rectangle-pro"
      "shottr"
      "signal"
      "skim"
      "soundsource"
      "steermouse"
      "tiptoi-manager"
      "tower"
      "viscosity"
      "visual-studio-code"
      "warp"
      "whatsapp"
      "zed"
      "zoom"
      "zotero-beta"
    ];
    masApps = {
      "1Password Safari" = 1569813296;
      "AusweisApp" = 948660805;
      "Bitwarden" = 1352778147;
      "Dropover" = 1355679052;
      "EasyLetter" = 1495179755;
      "Gapplin" = 768053424;
      "Goodnotes" = 1444383602;
      "Home Assistant" = 1099568401;
      "Kagi Search" = 1622835804;
      "Keka" = 470158793;
      "Kindle" = 302584613;
      "Meeting Owl" = 1219076447;
      "Mela" = 1568924476;
      "Microsoft Excel" = 462058435;
      "Microsoft Outlook" = 985367838;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;
      "OneDrive" = 823766827;
      "PDF Expert" = 1055273043;
      "Pitch" = 1551335606;
      "Prime Video" = 545519333;
      "Pure Paste" = 1611378436;
      "QR Factory" = 1609285899;
      "Raindrop.io Safari" = 1549370672;
      "Reeder" = 1529448980;
      "ShellFish" = 1336634154;
      "SnipNotes" = 967594709;
      "Step Two" = 1448916662;
      "StopTheMadness Pro" = 6471380298;
      "Tempus Stopwatch" = 1491326665;
      "TestFlight" = 899247664;
      "Todoist" = 585829637;
      "Vinegar" = 1591303229;
      "WhatsApp" = 310633997;
      "WireGuard" = 1451685025;
    };
  };
}
