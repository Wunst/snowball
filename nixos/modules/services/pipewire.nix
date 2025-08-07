{ config, lib, ... }:
let
  cfg = config.services.my-pipewire;
in
{
  options.services.my-pipewire.enable = lib.mkEnableOption "Enable pipewire";

  config = lib.mkIf cfg.enable {
    # Enable real time scheduling for low latency applications.
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      # Supported clients.
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };
}
