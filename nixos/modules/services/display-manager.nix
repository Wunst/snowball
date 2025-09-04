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
      displayManager.gdm.enable = true;
      xserver.enable = true;
    };
  };
}
