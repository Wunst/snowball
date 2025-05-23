{ ... }: {
  programs.firefox = {
    enable = true;

    # The more sane way to define settings.
    policies = {
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = true;
        Sessions = true;
        SiteSettings = true;
      };
      OverrideFirstRunPage = "";
      PromptForDownloadLocation = true;
      OfferToSaveLogins = false;
    };

    profiles.default = {
      isDefault = true;

      search = {
        default = "ddg"; # DuckDuckGo
        force = true; # Override search file.
      };

      # The less sane way, directly via about:config
      settings = {
        "browser.open_pdf_attachments_inline" = true;
        "extensions.autoDisableScopes" = 0;
      };
    };
  };
}
