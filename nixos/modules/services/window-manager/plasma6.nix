{ config, lib, ... }:
let
  cfg = config.services.bm-window-manager.plasma6;
in
{
  options.services.bm-window-manager.plasma6 = with lib; {
    enable = mkEnableOption "KDE Plasma as your window manager";
  };

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.defaultSession = "plasmax11";
    };
  };
}
