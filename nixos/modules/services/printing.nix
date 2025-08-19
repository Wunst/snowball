{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.my-printing;
in
{
  options.services.my-printing.enable = lib.mkEnableOption "Enable printing";

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      stateless = true;
      browsed.enable = false;
    };

    # Declare my printers.
    hardware.printers.ensurePrinters = [
      {
        name = "Matthies_ColorLaserJet";
        location = "";
        model = "everywhere"; # Generic IPP Everywhere.
        deviceUri = "ipp://DruckerM281fdw:631/ipp/print";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
  };
}
