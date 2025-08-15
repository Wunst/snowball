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
        # TODO: base16 theming
      };
    };
  };
}
