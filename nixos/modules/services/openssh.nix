{ config, lib, ... }:
let
  cfg = config.services.bm-openssh;
in
{
  options.services.bm-openssh = with lib; {
    enable = mkEnableOption "the OpenSSH server";
  };

  config = lib.mkIf cfg.enable {
    services = {
      openssh = {
        enable = true;

        settings = {
          # Harden SSH authentication.
          # Disallow root login.
          PermitRootLogin = "no";

          # Only allow secure, public key based authentication.
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;

          # Log failed login attempts. Required for fail2ban to work.
          LogLevel = "VERBOSE";
        };

        # Ignore the default authorized_keys file. Only use the keys declared in this config.
        authorizedKeysInHomedir = false;
      };

      fail2ban.enable = true;
    };
  };
}
