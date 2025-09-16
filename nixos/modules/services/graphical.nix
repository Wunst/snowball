{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bm-graphical;
in
{
  options.services.bm-graphical = with lib; {
    enable = mkEnableOption "the graphical environment";

    displayManager = mkOption {
      type = types.enum [
        "sddm"
      ];
    };

    windowManager = mkOption {
      type = types.enum [
        "plasma6"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver.enable = true;
      displayManager = {
        sddm = {
          enable = cfg.displayManager == "sddm";

          # Prettier theme.
          extraPackages = [ pkgs.kdePackages.plasma-desktop ];
          theme = "breeze";
        };
      };
      desktopManager = {
        plasma6.enable = cfg.windowManager == "plasma6";
      };
    };
  };
}
