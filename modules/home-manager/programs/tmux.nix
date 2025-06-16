{ config, lib, ... }: let
  cfg = config.programs.sn-tmux;
in {
  options = {
    programs.sn-tmux.enable = lib.mkEnableOption "Enable and configure tmux";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      shortcut = "a";
      mouse = true;
      terminal = "tmux-256color";
    };
  };
}
