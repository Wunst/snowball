{ config, lib, ... }:
let
  cfg = config.programs.bm-zsh;
in
{
  options.programs.bm-zsh = with lib; {
    enable = mkEnableOption "zsh";
  };

  config = lib.mkIf cfg.enable {
    # zsh with oh-my-zsh is my current daily driver.
    programs = {
      # Fuzzy completion tool.
      fzf.enable = true;

      zsh = {
        enable = true;
        oh-my-zsh = {
          enable = true;
          theme = "junkfood";
          plugins = [
            "tmux"
            "git"
            "ssh"
            "fzf"
          ];
        };
      };
    };
  };
}
