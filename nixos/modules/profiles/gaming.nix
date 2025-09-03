{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bm-profiles.gaming;
in
{
  options.bm-profiles.gaming = with lib; {
    enable = mkEnableOption "the gaming profile";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
      hyperrogue

      # Retro emulators.
      (retroarch.withCores (
        cores: with cores; [
          mesen
          bsnes
          dolphin
        ]
      ))
      rpcs3
    ];

    # This adds extra environment. Just installing the `steam` package will not work.
    programs.steam.enable = true;
  };
}
