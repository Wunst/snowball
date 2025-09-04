{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.bm-inkscape;
in
{
  options.programs.bm-inkscape = with lib; {
    enable = mkEnableOption "Inkscape";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.inkscape
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "image/svg+xml" = "org.inkscape.Inkscape.desktop";
      };
    };
  };
}
