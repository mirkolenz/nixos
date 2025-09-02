{ ... }:
let
  caskApps = [
    "1password"
    "alt-tab"
    "anydesk"
    "arq"
    "balenaetcher"
    "betterdisplay"
    "default-folder-x"
    "devonthink"
    "firefox"
    "fission"
    "forklift"
    "ghostty"
    "godspeed"
    "google-chrome"
    "handbrake-app"
    "jordanbaird-ice"
    "lookaway"
    "microsoft-auto-update"
    "microsoft-teams"
    "neohtop"
    "obsidian"
    "omnigraffle"
    "orbstack"
    "presentation"
    "raindropio"
    "raycast"
    "rode-central"
    "skim"
    "soundsource"
    "stats"
    "steermouse"
    "tailscale-app"
    "tiptoi-manager"
    "viscosity"
    "visual-studio-code"
    "wifiman"
    "zed"
    "zoom"
    "zotero@beta"
  ];

  masApps = {
    _1password-safari = 1569813296;
    aiko = 1672085276;
    ausweisapp = 948660805;
    base = 6744867438;
    bitwarden = 1352778147;
    daisydisk = 411643860;
    dropover = 1355679052;
    easyletter = 1495179755;
    gapplin = 768053424;
    home-assistant = 1099568401;
    kagi = 1622835804;
    keka = 470158793;
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
    testflight = 899247664;
    texstage = 6737460352;
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
    "blex-mono-nerd-font"
    "cascadia-code"
    "cascadia-code-nf"
    "cascadia-mono"
    "caskaydia-cove-nerd-font"
    "eagle-lake"
    "eb-garamond"
    "expletus-sans"
    "fira-code"
    "fira-code-nerd-font"
    "fira-mono"
    "fira-sans"
    "fontawesome"
    "geist"
    "geist-mono"
    "ia-writer-duo"
    "ia-writer-mono"
    "ia-writer-quattro"
    "ibm-plex-math"
    "ibm-plex-mono"
    "ibm-plex-sans"
    "ibm-plex-serif"
    "intel-one-mono"
    "inter"
    "intone-mono-nerd-font"
    "iosevka"
    "jetbrains-mono"
    "jetbrains-mono-nerd-font"
    "jost"
    "lugrasimo"
    "manrope"
    "monaspace"
    "monaspice-nerd-font"
    "overlock"
    "overlock-sc"
    "roboto"
    "roboto-flex"
    "roboto-mono"
    "roboto-serif"
    "roboto-slab"
    "source-code-pro"
    "source-sans-3"
    "source-serif-4"
    "tangerine"
    "tex-gyre-adventor"
    "tex-gyre-bonum"
    "tex-gyre-bonum-math"
    "tex-gyre-chorus"
    "tex-gyre-cursor"
    "tex-gyre-heros"
    "tex-gyre-pagella"
    "tex-gyre-pagella-math"
    "tex-gyre-schola"
    "tex-gyre-schola-math"
    "tex-gyre-termes"
    "tex-gyre-termes-math"
    "ubuntu"
    "ubuntu-condensed"
    "ubuntu-mono"
    "ubuntu-mono-nerd-font"
    "ubuntu-nerd-font"
    "ubuntu-sans"
    "ubuntu-sans-mono"
    "ubuntu-sans-nerd-font"
    "varela"
    "varela-round"
  ];
in
{
  environment.variables = {
    HOMEBREW_NO_ENV_HINTS = "1";
  };
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
    taps = [ ];
    brews = [ ];
    casks = caskApps ++ caskFonts;
    inherit masApps;
  };
}
