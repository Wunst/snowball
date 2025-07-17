{ config, lib, ... }: let
  cfg = config.my.services.openssh;
in {
  options.my.services.openssh.enable = lib.mkEnableOption "Enable openssh";

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}

