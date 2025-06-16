{ config, lib, ... }: let
  cfg = config.programs.sn-kitty;
in {
  options = {
    programs.sn-kitty.enable = lib.mkEnableOption "Enable and configure kitty";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      # TODO: font configuration
      settings = {
        cursor_trail = 50;
        window_padding_width = 24;
        # TODO: base16 theming
      };
    };
  };
}
