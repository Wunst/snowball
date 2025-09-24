{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bm-timeshift;
in
{
  options.services.bm-timeshift = with lib; {
    enable = mkEnableOption "the timeshift backup and restore service";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.timeshift
    ];

    # Required for daily backups to run!
    services.cron.enable = true;
  };
}
