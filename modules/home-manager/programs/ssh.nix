{ config, lib, ... }: let
  cfg = config.programs.sn-ssh;
in {
  options = {
    programs.sn-ssh.enable = lib.mkEnableOption "Enable and configure ssh client";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "homeassistant" = {
          hostname = "192.168.98.2";
          user = "root";
        };

        "switch-sg300" = {
          hostname = "192.168.98.8";
          user = "admin";
          identityFile = "~/.ssh/mgmt_id_rsa";
          extraOptions = {
            # This is an ancient switch using outdated encryption.
            KexAlgorithms = "diffie-hellman-group1-sha1";
            HostKeyAlgorithms = "ssh-rsa";
            PubkeyAcceptedAlgorithms = "ssh-rsa";
          };
        };
      };
    };

    # TODO: (password protected) private keys from sops
  };
}
