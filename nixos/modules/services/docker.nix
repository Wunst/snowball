{ config, lib, ... }:
let
  cfg = config.services.bm-docker;
in
{
  options.services.bm-docker = with lib; {
    enable = mkEnableOption "Docker";
  };

  config = lib.mkIf cfg.enable {
    # My development config.
    # TODO: Configure rootless Docker.
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";

        # Prune all images, but not local volumes. Lots of Dockerfiles online use local volumes, and I don't want to change it everywhere.
        flags = [
          "--all"
        ];
      };
    };
  };
}
