{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.roles.workstation;
in
{
  options.roles.workstation.enable = lib.mkEnableOption "Enable workstation";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Office.
      libreoffice-fresh
      synology-drive-client
      keepassxc

      # Creative.
      gimp
      krita
      inkscape
      blender
      audacity
      obs-studio

      # Social.
      discord

      # Multimedia.
      vlc
      ffmpeg-full
      spotify

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

      # Network.
      inetutils
      wireshark-qt
    ];

    programs = {
      bash.enable = true;
      my-zsh.enable = true;
      my-tmux.enable = true;
      my-kitty.enable = true;

      my-git = {
        enable = true;
        userName = "Ben Matthies";
        userEmail = "matthiesbe@gmail.com";
      };

      my-neovim = {
        enable = true;
        defaultEditor = true;
      };

      my-firefox.enable = true;
      my-thunderbird.enable = true;
    };

    # TODO: Configure mail accounts
  };
}
