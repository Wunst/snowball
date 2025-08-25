{ config, lib, ... }:
let
  cfg = config.programs.my-firefox;
in
{
  options.programs.my-firefox.enable = lib.mkEnableOption "Enable Firefox";

  config = lib.mkIf cfg.enable {
    # TODO: Rewrite firefox config, package extensions
    programs.firefox = {
      enable = true;

      policies = {
        SanitizeOnShutdown = true;
        PromptForDownloadLocation = true;
        OfferToSaveLogins = false;
        TranslateEnabled = false;
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
          default = "ddg";
          force = true; # Override search file.
        };

        settings = {
          "browser.open_pdf_attachments_inline" = true; # Firefox dumps PDF attachments in my downloads without prompting, WTF
          "extensions.autoDisableScopes" = 0;
        };
      };
    };
  };
}
