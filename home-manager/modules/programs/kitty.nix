{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.my-kitty;
in
{
  options.programs.my-kitty.enable = lib.mkEnableOption "Enable kitty";

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      # TODO: Configure fonts in some unified way
      font = {
        name = "Terminess NerdFont";
        package = pkgs.nerd-fonts.terminess-ttf;
        size = 18;
      };
      settings = {
        window_padding_width = 16;
        foreground = "#${config.theme.colors.foreground}";
        background = "#${config.theme.colors.background}";
      }
      // lib.listToAttrs (
        lib.zipListsWith (n: color: {
          name = "color${builtins.toString n}";
          value = "#${color}";
        }) (lib.range 0 15) config.theme.colors.colors
      );
    };
  };
}
