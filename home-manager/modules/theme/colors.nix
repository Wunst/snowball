{ config, lib, ... }:
let
  cfg = config.theme.colors;

  colorType = lib.types.strMatching "[0-9a-f]{6}";

  preconfiguredThemes = {
    solarized = [
      "002b36"
      "073642"
      "586e75"
      "657b83"
      "839496"
      "93a1a1"
      "eee8d5"
      "fdf6e3"
      "268bd2"
      "2aa198"
      "b58900"
      "859900"
      "d33682"
      "dc322f"
      "cb4b16"
      "6c71c4"
    ];

    gruvbox = [
      "282828"
      "3c3836"
      "504945"
      "665c54"
      "a89984"
      "d5c4a1"
      "ebdbb2"
      "fbf1c7"
      "458588"
      "b16286"
      "689d6a"
      "98971a"
      "d65d0e"
      "d79921"
      "cc241d"
      "928374"
    ];
  };
in
with lib;
{
  options.theme.colors = {
    colors = mkOption {
      type = types.listOf colorType;
      description = "List of base16 colors";
    };

    foreground = mkOption {
      type = colorType;
    };

    background = mkOption {
      type = colorType;
    };

    theme = mkOption {
      type =
        with types;
        submodule {
          options = {
            name = mkOption {
              type = enum (attrNames preconfiguredThemes);
              description = "Name of the base16 theme";
            };

            variant = mkOption {
              type = enum [
                "dark"
                "light"
              ];
              description = "Use the light or dark theme variant";
              default = "dark";
            };
          };
        };
      description = "Use a preconfigured base16 theme";
    };
  };

  config = {
    # TODO: Include some helper for formatting colors, e.g. kitty's color0 … color15 or base16's default base00 … base0F
    theme.colors = {
      colors = mkIf (cfg.theme.name != null) (
        (
          themeColors:
          if cfg.theme.variant == "light" then
            # To turn from dark to light in base16, reverse base00 to base07
            reverseList (sublist 0 8 themeColors) ++ (sublist 8 8 themeColors)
          else
            themeColors
        )
          preconfiguredThemes.${cfg.theme.name}
      );

      background = elemAt cfg.colors 0;
      foreground = elemAt cfg.colors 4;
    };
  };
}
