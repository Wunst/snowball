{ config, lib, ... }: let
  cfg = config.my.services.pipewire;
in {
  options.my.services.pipewire.enable = lib.mkEnableOption "Enable pipewire";

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true; # Allow real-time scheduling for low latency applications.
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

