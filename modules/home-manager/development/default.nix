{ pkgs, ... }: {
  home.packages = with pkgs; [
    # TODO: Clearly differentiate a development and graphical profile, e.g., is LateX graphical or dev? Octave? Godot? Blender?
    # Web dev.
    filezilla
    httpie
    jq
    phpPackages.composer # use a flake for php as well?

    # Embedded dev.
    clang-tools
    arduino-ide
    arduino-cli
    minicom

    # Game dev.
    godot_4
    godot_4-export-templates

    # Wireshark. System module must be enabled.
    wireshark-qt
  ];
}
