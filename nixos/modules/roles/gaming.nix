{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.roles.gaming;
in
{
  options.roles.gaming.enable = lib.mkEnableOption "Enable gaming";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
      hyperrogue
      (retroarch.withCores (
        cores: with cores; [
          mesen
          bsnes
          dolphin
          scummvm
        ]
      ))
      rpcs3
    ];

    # XXX This adds extra environment, just installing `steam` will not work!
    programs.steam.enable = true;
  };
}
