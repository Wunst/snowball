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
    services = {
      # I use `tlp` instead.
      power-profiles-daemon.enable = false;

      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          # Only charge between 20 and 80 percent.
          START_CHARGE_THRESH_BAT0 = 20;
          STOP_CHARGE_THRESH_BAT0 = 80;
        };
      };
    };
  };
}
