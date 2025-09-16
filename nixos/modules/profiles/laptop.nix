{ config, lib, ... }:
let
  cfg = config.bm-profiles.laptop;
in
{
  options.bm-profiles.laptop = with lib; {
    enable = mkEnableOption "the laptop profile";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;

    # Power management.
    services.bm-tlp.enable = true;
  };
}
