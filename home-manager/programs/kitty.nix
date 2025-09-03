{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.bm-kitty;
in
{
  options.programs.bm-kitty = with lib; {
    enable = mkEnableOption "kitty";
  };

  config = lib.mkIf cfg.enable {
    # TODO: Theming.
    programs.kitty = {
      enable = true;
      font = {
        name = "Terminess NerdFont";
        package = pkgs.nerd-fonts.terminess-ttf;
        size = 18;
      };
      settings = {
        cursor_trail = 100;
        window_padding_width = 16;
      };
    };
  };
}
