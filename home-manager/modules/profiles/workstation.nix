{
  osConfig,
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
    enable = mkOption {
      description = "Whether to enable the workstation profile";
      type = types.bool;
      default = osConfig.bm-profiles.workstation.enable or false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Office.
      libreoffice-fresh
      synology-drive-client
      keepassxc
      ghostscript

      # Creative.
      gimp
      krita
      inkscape
      blender
      audacity
      obs-studio
      freecad
      shotcut

      # Social.
      discord

      # Multimedia.
      vlc
      ffmpeg-full
      spotify
      yt-dlp

      # Scientific computing.
      wxmaxima
      octaveFull
      gnuplot

      # LaTeX.
      texliveFull
      enter-tex

      # Web dev.
      filezilla
      httpie
      jq

      # Embedded dev.
      arduino-ide
      minicom

      # Game dev.
      godot_4
      godot_4-export-templates-bin
    ];

    programs = {
      bash.enable = true;
      bm-zsh.enable = true;

      bm-tmux.enable = true;
      bm-kitty.enable = true;
      bm-firefox.enable = true;
      bm-thunderbird.enable = true;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "firefox.desktop";

        "image/svg+xml" = "org.inkscape.Inkscape.desktop";

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
