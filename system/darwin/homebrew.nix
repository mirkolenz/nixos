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
      cleanup = "zap";
    };
    caskArgs = {
      ignore_dependencies = true;
    };
    taps = [ ];
    brews = [ ];
    casks = [
      "1password"
      "adobe-creative-cloud"
      "alt-tab"
      "anydesk"
      "appcleaner"
      "arq"
      "balenaetcher"
      "betterdisplay"
      "cameracontroller"
      "cleanshot"
      "cursor"
      "ddpm"
      "default-folder-x"
      "devonthink"
      "discord"
      "element"
      "figma"
      "fission"
      "font-big-shoulders-display"
      "font-big-shoulders-inline-display"
      "font-big-shoulders-inline-text"
      "font-big-shoulders-stencil-display"
      "font-big-shoulders-stencil-text"
      "font-big-shoulders-text"
      "font-eagle-lake"
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
      "font-lugrasimo"
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
      "ghostty"
      "gitbutler"
      "godspeed"
      "google-chrome"
      "google-drive"
      "handbrake"
      "ia-presenter"
      "iterm2"
      "jordanbaird-ice"
      "juxtacode"
      "mediathekview"
      "microsoft-auto-update"
      "microsoft-teams"
      "notion"
      "obsidian"
      "omnigraffle"
      "orbstack"
      "orion"
      "parallels"
      "pixelsnap"
      "postman"
      "presentation"
      "raindropio"
      "raycast"
      "rode-central"
      "signal"
      "soundsource"
      "steermouse"
      "tailscale"
      "tiptoi-manager"
      "tower"
      "viscosity"
      "visual-studio-code"
      "warp"
      "wifiman"
      "zed"
      "zoom"
      "zotero"
    ];
    masApps = {
      "1password-safari" = 1569813296;
      "ausweisapp" = 948660805;
      "bitwarden" = 1352778147;
      "dropover" = 1355679052;
      "easyletter" = 1495179755;
      "gapplin" = 768053424;
      "goodnotes" = 1444383602;
      "home-assistant" = 1099568401;
      "kagi" = 1622835804;
      "keka" = 470158793;
      "kindle" = 302584613;
      "meeting-owl" = 1219076447;
      "mela" = 1568924476;
      "microsoft-excel" = 462058435;
      "microsoft-outlook" = 985367838;
      "microsoft-powerpoint" = 462062816;
      "microsoft-word" = 462054704;
      "onedrive" = 823766827;
      "pdf-expert" = 1055273043;
      "pure-paste" = 1611378436;
      "qr-factory" = 1609285899;
      "qr-pop" = 1587360435;
      "raindrop-io-safari" = 1549370672;
      "reeder" = 6475002485;
      "shellfish" = 1336634154;
      "step-two" = 1448916662;
      "stopthemadness-pro" = 6471380298;
      "tabback" = 1660506599;
      "testflight" = 899247664;
      "texstage" = 6737460352;
      "todoist" = 585829637;
      "vinegar" = 1591303229;
      "whatsapp" = 310633997;
    };
  };
}
