{ config, lib, ... }:
let
  cfg = config.programs.my-tmux;
in
{
  options.programs.my-tmux.enable = lib.mkEnableOption "Enable tmux";

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      shortcut = "a";
      mouse = true;
    };
  };
}
