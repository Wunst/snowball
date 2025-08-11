{ lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "synology-drive-client"
      "discord"
      "spotify"
      "steam"
      "steam-unwrapped"
    ];
}
