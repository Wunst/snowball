{ config, lib, ... }: let
  cfg = config.my.networking.networkmanager;
in {
  options.my.networking.networkmanager.enable = lib.mkEnableOption "Enable NetworkManager";

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}

