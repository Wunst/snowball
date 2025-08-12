{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.users.ben;
in
{
  options.users.ben.enable = lib.mkEnableOption "Enable ben";

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true; # Add zsh to the list of allowed shells.

    users.users.ben = {
      isNormalUser = true;
      description = "Ben";
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
      ];
      openssh.authorizedKeys = {
        keyFiles = [
          ./authorized_keys
        ];
      };
    };
  };
}
