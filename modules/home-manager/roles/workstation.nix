{ config, lib, pkgs, ... }: let
  cfg = config.roles.workstation;
in {
  options = {
    roles.workstation.enable = lib.mkEnableOption "Enable workstation role";
  };

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

      # Social.
      discord

      # Multimedia.
      vlc
      spotify

      # Scientific computing.
      wxmaxima
      octaveFull

      # LaTeX.
      texliveFull
      enter-tex
    ];

    programs = {
      # My modules with custom configuration.
      sn-kitty.enable = true;
      sn-firefox.enable = true;
      sn-thunderbird.enable = true;
    };
  };
}
