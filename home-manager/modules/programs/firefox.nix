{ config, lib, ... }:
let
  cfg = config.programs.bm-firefox;
in
{
  options.programs.bm-firefox = with lib; {
    enable = mkEnableOption "Firefox";
  };

  config = lib.mkIf cfg.enable {
    # TODO: Rewrite firefox config, package extensions.
    programs.firefox = {
      enable = true;

      # Policies are an abstraction layer around Firefox settings, and also keep us from making changes to the declared config via the settings menu.
      policies = {
        SanitizeOnShutdown = true;
        PromptForDownloadLocation = true;
        OfferToSaveLogins = false;

        # Install extensions.
        ExtensionSettings = {
          # Only allow this method of installation.
          "*".installation_mode = "blocked";

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

        # Some things can only be configured through the raw settings.
        Preferences = {
          # Firefox dumps PDF attachments in my downloads without prompting, WTF!
          "browser.open_pdf_attachments_inline" = true;

          # Disable translation popup, but don't disable translations entirely.
          "browser.translations.automaticallyPopup" = false;

          "extensions.autoDisableScopes" = 0;
        };
      };

      profiles.default = {
        isDefault = true;
        search = {
          default = "ddg";

          # Replace search file.
          force = true;
        };
      };
    };
  };
}
