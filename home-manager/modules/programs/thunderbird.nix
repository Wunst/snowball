{ config, lib, ... }:
let
  cfg = config.programs.my-thunderbird;
in
{
  options.programs.my-thunderbird.enable = lib.mkEnableOption "Enable Thunderbird";

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
        settings = {
          "intl.locale.requested" = "de"; # TODO: Install language pack
          "extensions.ui.dictionary.hidden" = true; # Disable spellcheck.
        };
      };
    };
  };
}
