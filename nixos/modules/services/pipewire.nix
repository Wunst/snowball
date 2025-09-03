{ config, lib, ... }:
let
  cfg = config.services.bm-pipewire;
in
{
  options.services.bm-pipewire = with lib; {
    enable = mkEnableOption "Pipewire";
  };

  config = lib.mkIf cfg.enable {
    # Allow real time scheduling for low latency applications.
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };

      # I don't know if I actually need this, but it can't hurt.
      jack.enable = true;
    };
  };
}
