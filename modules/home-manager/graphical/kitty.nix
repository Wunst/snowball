{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Terminess NerdFont";
      package = pkgs.nerd-fonts.terminess-ttf;
      size = 21;
    };
    settings = {
      window_padding_width = 24;
      # TODO: base16 theming
    };
  };
}
