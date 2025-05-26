{ ... }: {
  # This is required to be enabled system level, installing the `steam' package 
  # alone will not work.
  programs.steam.enable = true;
}
