{ config, lib, ... }:
let
  cfg = config.bm-boot;
in
{
  options.bm-boot = with lib; {
    enable = mkEnableOption "booting on UEFI with systemd-boot and Plymouth boot splash";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      # Boot loader.
      # systemd-boot for UEFI.
      loader = {
        efi.canTouchEfiVariables = true;

        systemd-boot = {
          enable = true;
          editor = false;

          # To save space on the boot partition, and so we can garbage collect old generations earlier.
          configurationLimit = 5;
        };
      };

      # Required for graphical decrypt prompt.
      initrd.systemd.enable = true;

      # Boot splash.
      # TODO: Can we modeset to 1920x1080 during boot?
      plymouth = {
        enable = true;
        theme = "breeze";
      };
    };
  };
}
