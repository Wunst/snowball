{ config, lib, pkgs, ... }: let
  cfg = config.my.services.printing;
in {
  options.my.services.printing.enable = lib.mkEnableOption "Enable printing";

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      stateless = true;
      browsed.enable = false; # cups-browsed seems to be an infinite source of vulnerabilities. I'll enter my printer IP myself, thank you.
      drivers = [
        pkgs.hplip # FIXME: This may not be the correct driver. Pages come out blank, with only images and no text, but only sometimes.
      ];
    };
    # Declare my printers.
    hardware.printers.ensurePrinters = [
      { name = "Matthies_Drucker";
        model = "HP/hp-color_laserjet_mfp_m278-m281-ps.ppd.gz";
        deviceUri = "ipp://DruckerM281fdw.local:631/ipp/print"; }
    ];
  };
}

