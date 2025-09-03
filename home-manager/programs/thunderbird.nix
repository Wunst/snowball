{ config, lib, ... }:
let
  cfg = config.programs.bm-thunderbird;
in
{
  options.programs.bm-thunderbird = with lib; {
    enable = mkEnableOption "Thunderbird";
  };

  config = lib.mkIf cfg.enable {
    # TODO: Package extensions.
    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
        settings = {
          # TODO: Configure spellcheck for English and German.
          # Disable spellcheck.
          "extensions.ui.dictionary.hidden" = true;
        };
      };
    };
  };
}
