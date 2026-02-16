{ ... }:
let
  allowedSites = [
    "https://scratch.mit.edu/*"
  ];
in
{
  programs.firefox.policies = {
    WebsiteFilter = {
      Block = [ "<all_urls>" ];
      Exceptions = allowedSites;
    };

    Homepage = {
      URL = "https://scratch.mit.edu";
      Locked = true;
      StartPage = "homepage";
    };

    BlockAboutConfig = true;
    DisableDeveloperTools = true;
    DisableFirefoxAccounts = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisablePrivateBrowsing = true;
    DisableProfileImport = true;
    DisableProfileRefresh = true;
    DisableSafeMode = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;
    DownloadRestrictions = 3;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;

    DisableSecurityBypass = {
      InvalidCertificate = true;
      SafeBrowsing = true;
    };

    ExtensionSettings."*" = {
      installation_mode = "blocked";
    };

    HttpsOnlyMode = "enabled";
  };
}
