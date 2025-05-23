{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Terminess NerdFont";
      package = pkgs.nerd-fonts.terminess-ttf;
      size = 21;
    };
  };
}
