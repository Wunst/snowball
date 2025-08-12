{ config, lib, ... }:
let
  cfg = config.services.my-docker;
in
{
  options.services.my-docker = with lib; {
    enable = mkEnableOption "Enable docker";
    prune = mkOption {
      type = types.enum [
        true
        false
        "volumes"
      ];
      description = "Configure automatic pruning";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = cfg.prune != false;
        flags = if cfg.prune == "volumes" then [ "--volumes" ] else [ ];
      };
    };
  };
}
