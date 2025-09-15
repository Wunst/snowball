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

    windowManager = mkOption {
      description = "Which window manager to use. At least one must be selected.";
      type = types.enum [
        "plasma6"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    bm-boot.enable = true;
    bm-nix.enable = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Enable wireless networking with NetworkManager.
    networking.networkmanager.enable = true;

    # Update all firmware and microcode.
    hardware.enableRedistributableFirmware = true;

    services = {
      fwupd.enable = true;

      bm-openssh.enable = true;

      # Graphical target.
      bm-display-manager.enable = true;
      bm-window-manager = {
        plasma6.enable = cfg.windowManager == "plasma6";
      };

      bm-pipewire.enable = true;
      bm-printing.enable = true;

      # Docker for development.
      bm-docker.enable = true;
    };
  };
}
