{ config, lib, ... }:
let
  cfg = config.services.my-openssh;
in
{
  options.services.my-openssh.enable = lib.mkEnableOption "Enable OpenSSH";

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
