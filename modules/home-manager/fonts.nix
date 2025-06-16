{ config, lib, ... }: let
  fontType = 
    with lib; with types; submodule {
      name = mkOption {
        type = str;
        description = "Font name";
      };

      size = mkOption {
        type = int;
        description = "Font size";
        default = 12;
      };

      package = mkOption {
        type = nullOr package;
        description = "Package containing the font";
        default = null;
      };
    };

  cfg = config.sn-fonts;
in {
  options = {
    sn-fonts = with lib; {
      serif = mkOption {
        type = fontType;
        default = {
          name = "serif";
        };
      };

      sans = mkOption {
        type = fontType;
        default = {
          name = "sans-serif";
        };
      };

      monospace = mkOption {
        type = fontType;
        default = {
          name = "monospace";
        };
      };
    };
  };
}
