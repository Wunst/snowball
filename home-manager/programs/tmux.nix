{ config, lib, ... }:
let
  cfg = config.programs.tmux;
in
{
  options.programs.bm-tmux = with lib; {
    enable = mkEnableOption "tmux";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      # TODO: Vim bindings for navigations.
      # Vim bindings in copy mode.
      keyMode = "vi";

      shortcut = "a";
      terminal = "tmux-256color";
      mouse = true;
    };
  };
}
