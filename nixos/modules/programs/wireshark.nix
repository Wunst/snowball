{ config, lib, ... }: let
  cfg = config.my.programs.wireshark;
in {
  options.my.programs.wireshark.enable = lib.mkEnableOption "Enable wireshark";

  config = lib.mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      dumpcap.enable = true; # Network packet capture.
      usbmon.enable = true; # USB capture.
    };
  };
}

