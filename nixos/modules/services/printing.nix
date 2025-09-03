{ config, lib, ... }:
let
  cfg = config.services.bm-printing;
in
{
  options.services.bm-printing = with lib; {
    enable = mkEnableOption "printing";
  };

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      stateless = true;

      # cups-browsed seems to be an infinite source of security vulnerabilities. I'll enter my printer IP myself, thank you.
      browsed.enable = false;
    };
  };
}
