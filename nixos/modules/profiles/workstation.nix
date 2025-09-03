{ config, lib, ... }:
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

    # Enable wireless networking with NetworkManager.
    networking.networkmanager.enable = true;

    # Update all firmware and microcode.
    hardware.enableRedistributableFirmware = true;

    services = {
      fwupd.enable = true;

      bm-openssh.enable = true;

      # Graphical target.
      # TODO: Refactor to support different window managers.
      displayManager = {
        defaultSession = "plasmax11";
        gdm = {
          enable = true;

          # Suspending kills my machine with proprietary nvidia drivers.
          autoSuspend = true;
        };
      };
      desktopManager.plasma6.enable = true;
      xserver.enable = true;

      bm-pipewire.enable = true;
      bm-printing.enable = true;

      # Docker for development.
      bm-docker.enable = true;
    };
  };
}
