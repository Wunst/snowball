{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bm-profiles.workstation;
in
{
  options.bm-profiles.workstation = with lib; {
    enable = mkEnableOption "the workstation profile";
  };

  config = lib.mkIf cfg.enable {
    bm-boot.enable = true;
    bm-nix.enable = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Enable wireless networking with NetworkManager.
    networking.networkmanager.enable = true;

    services = {
      fwupd.enable = true;
      bm-openssh.enable = true;
      bm-graphical.enable = true;
      bm-pipewire.enable = true;
      bm-printing.enable = true;
      bm-timeshift.enable = true;

      # Docker for development.
      bm-docker.enable = true;
    };
  };
}
