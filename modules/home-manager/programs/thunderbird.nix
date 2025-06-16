{ config, lib, ... }: let
  cfg = config.programs.sn-thunderbird;
in {
  options = {
    programs.sn-thunderbird.enable = lib.mkEnableOption "Enable and configure thunderbird";
  };

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles.default = {
        # I think this is necessary to declare accounts.
        isDefault = true;
        settings = {
          # Again, this is bad design. I have given up on trying to install dictionaries and languages, need to use GUI(ewwy...).
          "intl.locale.requested" = "de";
          "extensions.ui.dictionary.hidden" = true; # Disable dictionary.
        };
      };
    };
  };
}
