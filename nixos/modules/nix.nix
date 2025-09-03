{ config, lib, ... }:
let
  cfg = config.bm-nix;
in
{
  options.bm-nix = with lib; {
    enable = mkEnableOption "Nix with flakes";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        # Enable flakes.
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        # Disable global registry.
        # Flake registries provide implicit common inputs to flakes and dev shells. I count this as an impurity.
        # TODO: Learn more about global, system, and user registries.
        flake-registry = "";
      };

      # Disable channels. We use flakes.
      channel.enable = false;

      gc = {
        automatic = true;
        dates = "weekly";
      };
      optimise = {
        automatic = true;
        dates = "weekly";
      };
    };
  };
}
