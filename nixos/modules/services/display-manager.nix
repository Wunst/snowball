{ config, lib, ... }:
let
  cfg = config.services.bm-display-manager;
in
{
  options.services.bm-display-manager = with lib; {
    enable = mkEnableOption "the display manager";
  };

  config = lib.mkIf cfg.enable {
    services = {
      # Configure the display manager here, but the actual window manager for each user in their home-manager config.
      displayManager.gdm = {
        enable = true;

        # Suspending kills my machine with proprietary nvidia drivers.
        autoSuspend = true;
      };
      xserver.enable = true;
    };
  };
}
