{ config, lib, ... }: let
  cfg = config.my.services.fwupd;
in {
  options.my.services.fwupd.enable = lib.mkEnableOption "Enable fwupd";

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
    
