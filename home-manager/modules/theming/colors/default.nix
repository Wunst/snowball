{ config, lib, ... }:
let
  cfg = config.theming.colors;

  namedColorSchemes = {
    solarized = builtins.fromTOML (builtins.readFile ./solarized.toml);
  };

  applyVariant =
    variant: colors:
    if variant == "light" then
      {
        inherit (colors) colors;
        base16 =
          colors.base16
          // (with colors.base16; {
            # Reverse the order of tones from dark to light.
            base00 = base07;
            base01 = base06;
            base02 = base05;
            base03 = base04;
            base04 = base03;
            base05 = base02;
            base06 = base01;
            base07 = base00;
          });
      }
    else
      colors;
in
{
  options.theming.colors = with lib; {
    colors = mkOption {
      description = "Use a set of color values";
      type = types.submodule {
        options =
          let
            mkColor = mkOption { type = types.strMatching "[0-9a-f]{6}"; };
          in
          {
            colors = {
              black = mkColor;
              red = mkColor;
              green = mkColor;
              yellow = mkColor;
              blue = mkColor;
              magenta = mkColor;
              cyan = mkColor;
              white = mkColor;

              brblack = mkColor;
              brred = mkColor;
              brgreen = mkColor;
              bryellow = mkColor;
              brblue = mkColor;
              brmagenta = mkColor;
              brcyan = mkColor;
              brwhite = mkColor;
            };

            base16 = {
              base00 = mkColor;
              base01 = mkColor;
              base02 = mkColor;
              base03 = mkColor;
              base04 = mkColor;
              base05 = mkColor;
              base06 = mkColor;
              base07 = mkColor;
              base08 = mkColor;
              base09 = mkColor;
              base0A = mkColor;
              base0B = mkColor;
              base0C = mkColor;
              base0D = mkColor;
              base0E = mkColor;
              base0F = mkColor;
            };
          };
      };
    };

    theme = mkOption {
      description = "Use a named color scheme";
      type = types.submodule {
        options = {
          name = mkOption {
            description = "Color scheme name";
            type = types.enum (builtins.attrNames namedColorSchemes);
          };

          variant = mkOption {
            description = "Use the light or dark variant of the scheme";
            type = types.enum [
              "light"
              "dark"
            ];
            default = "dark";
          };
        };
      };
      default = null;
    };
  };

  config = {
    theming.colors.colors = lib.mkIf (cfg.theme != null) (
      applyVariant cfg.theme.variant namedColorSchemes.${cfg.theme.name}
    );
  };
}
