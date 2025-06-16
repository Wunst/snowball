{ config, lib, ... }: let
  cfg = config.programs.sn-firefox;
in {
  options = {
    programs.sn-firefox.enable = lib.mkEnableOption "Enable and configure firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      # Firefox is a PITA to configure.
      # Policies are a quite reasonable system, but prevent the user from making changes. Maybe that's good actually.
      policies = {
        # Sanitizes all, including history! I want to use bookmarks instead. :p
        SanitizeOnShutdown = true;

        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";

        PromptForDownloadLocation = true;

        OfferToSaveLogins = false;

        SearchEngines = {
          Default = "DuckDuckGo";
        };

        # Raw settings.
        # A system similiarly insane to the Windows registry, but alas, we're stuck with it.
        Preferences = {
          "extensions.autoDisableScopes" = 0;

          "browser.open_pdf_attachments_inline" = true; # Stop putting all PDFs in my Downloads folder.
          "browser.translations.neverTranslateLanguages" = "de,en";
        };

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
    };
  };
}
