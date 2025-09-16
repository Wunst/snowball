{ lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "nvidia-settings"
      "nvidia-x11"
      "spotify"
      "steam"
      "steam-unwrapped"
      "synology-drive-client"
    ];

  # Update all firmware and microcode.
  hardware.enableRedistributableFirmware = true;
}
