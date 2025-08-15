{ config, lib, ... }:
let
  cfg = config.theming;
in
{
  imports = [
    ./colors
    ./targets/kitty.nix
    ./targets/neovim.nix
  ];

  options.theming.enableAll = lib.mkEnableOption "Enable all theming targets";

  config = lib.mkIf cfg.enableAll {
    theming.targets = {
      kitty.enable = true;
      neovim.enable = true;
    };
  };
}
