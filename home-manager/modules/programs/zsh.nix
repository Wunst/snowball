{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.my-zsh;
in
{
  options.programs.my-zsh.enable = lib.mkEnableOption "Enable zsh";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fzf # Fuzzy completion tool.
    ];

    programs.zsh = {
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
}
