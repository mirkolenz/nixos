{...}: {
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
      "bartender"
      "cleanshot"
      "contexts"
      "coteditor"
      "dadroit-json-viewer"
      "default-folder-x"
      "devonthink"
      "diffusionbee"
      "discord"
      "element"
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
      "font-source-sans-pro"
      "font-source-serif-pro"
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
      "iterm2"
      "lunar"
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
      "vivaldi"
      "whatsapp"
      "zed"
      "zoom"
      "zotero-beta"
    ];
  };
}
