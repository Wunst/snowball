{ config, lib, ... }: let
  cfg = config.programs.sn-git;
in {
  options = {
    programs.sn-git = 
      with lib; {
        enable = mkEnableOption "Enable and configure git";

        user = {
          name = mkOption {
            type = str;
            description = "Git user name";
          };

          email = mkOption {
            type = str;
            description = "Git user email";
          };
        };

        gh.user = mkOption {
          type = str;
          description = "GitHub user name";
        };
      };
  };

  config = {
    programs = {
      git = {
        enable = true;

        config = {
          init.defaultBranch = "main";

          user = {
            name = cfg.user.name;
            email = cfg.user.email;
          };
        };
      };

      gh = {
        enable = true;
        hosts = {
          "github.com" = {
            # TODO: configure oauth_token, supply via GH_TOKEN, or leave be?
            user = cfg.gh.user;
          };
        };
      };
    };
  };
}
