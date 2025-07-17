{ config, lib, pkgs, ... }: let
  cfg = config.my.users.ben;
in {
  options.my.users.ben.enable = lib.mkEnableOption "Enable user ben";

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true; # Enable zsh as a login shell.
    users.users.ben = {
      isNormalUser = true;
      description = "Ben";
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "dialout" # Allow me to use the serial ports directly, e.g. to flash embedded devices.
        "wireshark"
      ];
    };
  };
}

