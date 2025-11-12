{ config, ... }:
let
  caskApps = [
    "1password"
    "affinity"
    "alt-tab"
    "anydesk"
    "arq"
    "balenaetcher"
    "betterdisplay"
    "chatgpt"
    "daisydisk"
    "default-folder-x"
    "devonthink"
    "element"
    "firefox"
    "fission"
    "forklift"
    "fujitsu-scansnap-home"
    "ghostty"
    "google-chrome"
    "handbrake-app"
    "lm-studio"
    "lookaway"
    "macwhisper"
    "microsoft-auto-update"
    "microsoft-teams"
    "obsidian"
    "ollama-app"
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
    "sublime-merge"
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
    ausweisapp = 948660805;
    base = 6744867438;
    bitwarden = 1352778147;
    dropover = 1355679052;
    easyletter = 1495179755;
    gapplin = 768053424;
    home-assistant = 1099568401;
    keka = 470158793;
    mela = 1568924476;
    microsoft-excel = 462058435;
    microsoft-onedrive = 823766827;
    microsoft-powerpoint = 462062816;
    microsoft-windows = 1295203466;
    microsoft-word = 462054704;
    pdf-expert = 1055273043;
    qr-factory = 1609285899;
    reeder = 6475002485;
    safari-1password = 1569813296;
    safari-kagi = 1622835804;
    safari-raindropio = 1549370672;
    shellfish = 1336634154;
    step-two = 1448916662;
    stopthemadness-pro = 6471380298;
    testflight = 899247664;
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
  homebrew = {
    enable = true;
    global.autoUpdate = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    taps = [ ];
    brews = [ ];
    casks = caskApps ++ caskFonts;
    # inherit masApps;
  };
  environment.loginShellInit = ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';
}
