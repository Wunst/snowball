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
