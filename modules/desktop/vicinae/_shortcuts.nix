# Vicinae shortcuts, imported by ./default.nix.
# The leading underscore hides this data file from import-tree.
#
# Placeholders in a link (https://docs.vicinae.com/shortcuts):
# - `{name}` declares an argument that has to be typed in the search bar.
# - `{argument name="channel" default="unstable"}` is the same with a default value.
# - `{clipboard}`, `{selection}`, `{uuid}`, and `{date}` expand on their own.
# A shortcut with exactly one argument doubles as a fallback command,
# automatically expanding placeholders do not count towards that.
#
# Icons are `icon://<type>/<name>`, where the type is one of `favicon`, `builtin`,
# `emoji`, or `local`. Builtin icons ship as brand-colored or white SVGs, so the
# monochrome ones need `?fill=primary-text` to follow the active theme.
{
  # keep-sorted start block=yes
  "cashback-optimizer" = {
    url = "https://cashback-optimizer.de/?filter={query}";
    icon = "icon://favicon/cashback-optimizer.de";
  };
  "claude code changelog" = {
    url = "https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md";
    icon = "icon://favicon/github.com";
  };
  "codex changelog" = {
    url = "https://github.com/openai/codex/releases/latest";
    icon = "icon://favicon/github.com";
  };
  "ctan" = {
    url = "https://ctan.org/pkg/{package}";
    icon = "icon://favicon/ctan.org";
  };
  "dblp" = {
    url = "https://dblp.uni-trier.de/rec/{clipboard}.html";
    icon = "icon://favicon/dblp.uni-trier.de";
  };
  "dfki calendar" = {
    url = "https://outlook.office.com/calendar/view/workweek";
    icon = "icon://favicon/outlook.office.com";
  };
  "docker hub" = {
    url = "https://hub.docker.com/r/{path}";
    icon = "icon://favicon/hub.docker.com";
  };
  "doi" = {
    url = "https://doi.org/{clipboard}";
    icon = "icon://favicon/doi.org";
  };
  "font awesome brand" = {
    url = "https://fontawesome.com/search?ip=brands&ic=free-collection&q={query}";
    icon = "icon://favicon/fontawesome.com";
  };
  "font awesome free" = {
    url = "https://fontawesome.com/search?ic=free-collection&ip=classic&s=solid&q={query}";
    icon = "icon://favicon/fontawesome.com";
  };
  "github api" = {
    url = "https://api.github.com/{path}";
    icon = "icon://favicon/github.com";
  };
  "github" = {
    url = "https://github.com/{path}";
    icon = "icon://favicon/github.com";
  };
  "google" = {
    url = "https://google.com/search?q={query}";
    icon = "icon://favicon/google.com";
  };
  "home manager docs" = {
    url = "https://nix-community.github.io/home-manager/options.xhtml";
    icon = "icon://favicon/nix-community.github.io";
  };
  "home manager issues" = {
    url = "https://github.com/nix-community/home-manager/issues?q={query}";
    icon = "icon://favicon/github.com";
  };
  "home manager search" = {
    url = "https://home-manager-options.extranix.com/?query={query}&release={argument name=\"channel\" default=\"master\"}";
    icon = "icon://favicon/home-manager-options.extranix.com";
  };
  "huggingface" = {
    url = "https://huggingface.co/{path}";
    icon = "icon://favicon/huggingface.co";
  };
  "idealo" = {
    url = "https://www.idealo.de/preisvergleich/MainSearchProductCategory.html?q={query}";
    icon = "icon://favicon/www.idealo.de";
  };
  "kagi assistant" = {
    url = "https://kagi.com/assistant?q={query}&profile={argument name=\"model\" default=\"gpt-4o\"}&internet={argument name=\"internet\" default=\"true\"}";
    icon = "icon://favicon/kagi.com";
  };
  "kagi" = {
    url = "https://kagi.com/search?q={query}";
    icon = "icon://favicon/kagi.com";
  };
  "linguee" = {
    url = "https://www.linguee.com/english-german/search?source=auto&query={query}";
    icon = "icon://favicon/www.linguee.com";
  };
  "nix darwin docs" = {
    url = "https://nix-darwin.github.io/nix-darwin/manual/";
    icon = "icon://favicon/nix-darwin.github.io";
  };
  "nix darwin issues" = {
    url = "https://github.com/nix-darwin/nix-darwin/issues?q={query}";
    icon = "icon://favicon/github.com";
  };
  "nix docs" = {
    url = "https://nix.dev/manual/nix/latest/";
    icon = "icon://favicon/nix.dev";
  };
  "nixos changelog" = {
    url = "https://nixos.org/manual/nixos/unstable/release-notes";
    icon = "icon://favicon/nixos.org";
  };
  "nixos docs" = {
    url = "https://nixos.org/manual/nixos/unstable/";
    icon = "icon://favicon/nixos.org";
  };
  "nixos search" = {
    url = "https://search.nixos.org/options?query={query}&channel={argument name=\"channel\" default=\"unstable\"}";
    icon = "icon://favicon/search.nixos.org";
  };
  "nixpkgs docs" = {
    url = "https://nixos.org/manual/nixpkgs/unstable/";
    icon = "icon://favicon/nixos.org";
  };
  "nixpkgs issues" = {
    url = "https://github.com/nixos/nixpkgs/issues?q={query}";
    icon = "icon://favicon/github.com";
  };
  "nixpkgs search" = {
    url = "https://search.nixos.org/packages?query={query}&channel={argument name=\"channel\" default=\"unstable\"}";
    icon = "icon://favicon/search.nixos.org";
  };
  "nixpkgs tracker" = {
    url = "https://nixpkgs-tracker.ocfox.me/?pr={clipboard}";
    icon = "icon://favicon/nixpkgs-tracker.ocfox.me";
  };
  "nixvim docs" = {
    url = "https://nix-community.github.io/nixvim/";
    icon = "icon://favicon/nix-community.github.io";
  };
  "nixvim issues" = {
    url = "https://github.com/nix-community/nixvim/issues?q={query}";
    icon = "icon://favicon/github.com";
  };
  "noogle" = {
    url = "https://noogle.dev/q?term={query}";
    icon = "icon://favicon/noogle.dev";
  };
  "npm" = {
    url = "https://www.npmjs.com/package/{package}";
    icon = "icon://favicon/www.npmjs.com";
  };
  "npmx" = {
    url = "https://www.npmx.dev/package/{package}";
    icon = "icon://favicon/www.npmx.dev";
  };
  "pypi" = {
    url = "https://pypi.org/project/{package}";
    icon = "icon://favicon/pypi.org";
  };
  "searchix" = {
    url = "https://searchix.alanpearce.eu/{argument name=\"scope\" default=\"all\"}/search?query={query}";
    icon = "icon://builtin/magnifying-glass?fill=primary-text";
  };
  "typst universe" = {
    url = "https://typst.app/universe/package/{package}/";
    icon = "icon://favicon/typst.app";
  };
  "x" = {
    url = "https://twitter.com/i/web/status/{clipboard}";
    icon = "icon://favicon/twitter.com";
  };
  # keep-sorted end
}
