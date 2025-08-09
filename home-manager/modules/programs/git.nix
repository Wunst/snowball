{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.my-git;
in
{
  options.programs.my-git = with lib; {
    enable = mkEnableOption "Enable git";
    userName = mkOption {
      type = types.str;
      description = "Git commit identity";
    };
    userEmail = mkOption {
      type = types.str;
      description = "Git commit e-mail";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        inherit (cfg) userName userEmail;

        extraConfig = {
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          url = {
            # We can write GitHub URLs as `github:user/repo`.
            "https://github.com/" = {
              insteadOf = "github:";
            };
          };
        };
      };

      gh.enable = true; # GitHub credential helper.
    };
  };
}
