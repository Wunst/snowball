{ lib, ... }: {
  nixpkgs.config.allowUnfreePredicate =
    p: builtins.elem (lib.getName p) [
      "discord"
      "nvidia-x11"
      "nvidia-settings"
      "hplip"
      "spotify"
      "synology-drive-client"
    ];
}
