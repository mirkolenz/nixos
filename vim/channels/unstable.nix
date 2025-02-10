{ pkgs, ... }:
{
  plugins.lsp.ltex_plus = {
    enable = true;
    package = pkgs.ltex-ls-plus;
    settings.ltex = {
      language = "en-US";
      additionalRules.motherTongue = "de-DE";
    };
  };
}
