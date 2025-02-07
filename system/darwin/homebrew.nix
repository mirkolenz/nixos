{ ... }:
let
  caskApps = [
    "1password"
    "adobe-creative-cloud"
    "alt-tab"
    "anydesk"
    "arq"
    "balenaetcher"
    "betterdisplay"
    "cameracontroller"
    "cleanshot"
    "cursor"
    "default-folder-x"
    "devonthink"
    "discord"
    "element"
    "figma"
    "fission"
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
    "sioyek"
    "skim"
    "soundsource"
    "stats"
    "steermouse"
    "tailscale"
    "tiptoi-manager"
    "tower"
    "viscosity"
    "visual-studio-code"
    "vivaldi"
    "wifiman"
    "zed"
    "zed@preview"
    "zoom"
    "zotero"
  ];

  masApps = {
    _1password-safari = 1569813296;
    ausweisapp = 948660805;
    bitwarden = 1352778147;
    dropover = 1355679052;
    easyletter = 1495179755;
    gapplin = 768053424;
    goodnotes = 1444383602;
    home-assistant = 1099568401;
    kagi = 1622835804;
    keka = 470158793;
    kindle = 302584613;
    meeting-owl = 1219076447;
    mela = 1568924476;
    microsoft-excel = 462058435;
    microsoft-outlook = 985367838;
    microsoft-powerpoint = 462062816;
    microsoft-word = 462054704;
    onedrive = 823766827;
    pdf-expert = 1055273043;
    pure-paste = 1611378436;
    qr-factory = 1609285899;
    qr-pop = 1587360435;
    raindrop-io-safari = 1549370672;
    reeder = 6475002485;
    shellfish = 1336634154;
    step-two = 1448916662;
    stopthemadness-pro = 6471380298;
    tabback = 1660506599;
    testflight = 899247664;
    texstage = 6737460352;
    todoist = 585829637;
    vinegar = 1591303229;
    whatsapp = 310633997;
  };

  caskFonts = map (name: "font-${name}") [
    "big-shoulders-display"
    "big-shoulders-inline-display"
    "big-shoulders-inline-text"
    "big-shoulders-stencil-display"
    "big-shoulders-stencil-text"
    "big-shoulders-text"
    "eagle-lake"
    "eb-garamond"
    "expletus-sans"
    "fira-code-nerd-font"
    "fira-code"
    "fira-mono"
    "fira-sans"
    "fontawesome"
    "geist-mono"
    "geist"
    "ia-writer-duo"
    "ia-writer-mono"
    "ia-writer-quattro"
    "ibm-plex"
    "inter"
    "iosevka"
    "jetbrains-mono-nerd-font"
    "jetbrains-mono"
    "jost"
    "lugrasimo"
    "manrope"
    "monaspace"
    "overlock-sc"
    "overlock"
    "roboto-flex"
    "roboto-mono"
    "roboto-serif"
    "roboto-slab"
    "roboto"
    "source-code-pro"
    "source-sans-3"
    "source-serif-4"
    "tangerine"
    "tex-gyre-adventor"
    "tex-gyre-bonum-math"
    "tex-gyre-bonum"
    "tex-gyre-chorus"
    "tex-gyre-cursor"
    "tex-gyre-heros"
    "tex-gyre-pagella-math"
    "tex-gyre-pagella"
    "tex-gyre-schola-math"
    "tex-gyre-schola"
    "tex-gyre-termes-math"
    "tex-gyre-termes"
    "ubuntu-mono-nerd-font"
    "ubuntu-mono"
    "ubuntu-nerd-font"
    "ubuntu"
    "varela-round"
    "zed-mono"
    "zed-mono-nerd-font"
    "zed-sans"
  ];
in
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
    taps = [ ];
    brews = [ ];
    casks = caskApps ++ caskFonts;
    inherit masApps;
  };
}
