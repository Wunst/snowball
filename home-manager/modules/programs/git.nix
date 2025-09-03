{ config, lib, ... }:
let
  cfg = config.programs.bm-git;
in
{
  options.programs.bm-git = with lib; {
    enable = mkEnableOption "git, and the GitHub CLI and credential helper";

    userName = mkOption {
      description = "Default user name to use.";
      type = types.str;
    };

    userEmail = mkOption {
      description = "Default user email to use.";
      type = types.str;
    };

    githubTokenFile = mkOption {
      description = "Path to GitHub token file, in my case from sops-nix.";
      type = with types; nullOr str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    # Supply OAuth token.
    home.sessionVariables = lib.mkIf (cfg.githubTokenFile != null) {
      GITHUB_TOKEN = "$(cat ${cfg.githubTokenFile})";
    };

    programs = {
      git = {
        enable = true;
        userName = cfg.userName;
        userEmail = cfg.userEmail;
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

      # Enable credential helper.
      gh.enable = true;
    };
  };
}
