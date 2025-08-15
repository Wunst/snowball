{ config, lib, ... }:
with config.theming;
let
  cfg = config.theming.targets.kitty;
in
{
  options.theming.targets.kitty.enable = lib.mkEnableOption "Enable theming for kitty";

  config = lib.mkIf cfg.enable {
    programs.kitty.settings =
      (with colors.colors.base16; {
        background = "#${base00}";
        foreground = "#${base05}";
      })
      // (with colors.colors.colors; {
        color0 = "#${black}";
        color1 = "#${red}";
        color2 = "#${green}";
        color3 = "#${yellow}";
        color4 = "#${blue}";
        color5 = "#${magenta}";
        color6 = "#${cyan}";
        color7 = "#${white}";
        color8 = "#${brblack}";
        color9 = "#${brred}";
        color10 = "#${brgreen}";
        color11 = "#${bryellow}";
        color12 = "#${brblue}";
        color13 = "#${brmagenta}";
        color14 = "#${brcyan}";
        color15 = "#${brwhite}";
      });
  };
}
