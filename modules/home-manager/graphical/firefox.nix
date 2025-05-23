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
      TranslateEnabled = false;

      # Extensions.
      ExtensionSettings = {
        "*".installation_mode = "blocked"; # Only allow this method of installation.
        # uBlock Origin.
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # PrivacyBadger.
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        # KeepassXC-Browser.
        "keepassxc-browser@keepassxc.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
          installation_mode = "force_installed";
        };
      };
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
