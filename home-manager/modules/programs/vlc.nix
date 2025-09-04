{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.bm-vlc;
in
{
  options.programs.bm-vlc = with lib; {
    enable = mkEnableOption "VLC media player";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vlc
      ffmpeg-full
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "audio/aac" = "vlc.desktop";
        "audio/mpeg" = "vlc.desktop";
        "audio/ogg" = "vlc.desktop";
        "audio/wav" = "vlc.desktop";
        "audio/webm" = "vlc.desktop";

        "video/mpeg" = "vlc.desktop";
        "video/ogg" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
      };
    };
  };
}
