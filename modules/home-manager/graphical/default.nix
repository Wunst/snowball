{ pkgs, ... }: {
  imports = [
    ./kitty.nix
    ./firefox.nix
    ./email.nix
    ./gaming.nix
  ];

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
    ffmpeg-full
    spotify

    # Scientific computing.
    wxmaxima
    octaveFull

    # LaTeX.
    texliveFull
    enter-tex
  ];
}
