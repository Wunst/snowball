{ config, pkgs, sops, ... }: {
  imports = [
    ./editor
    ./graphical
  ];

  home.username = "ben";
  home.homeDirectory = "/home/ben";

  home.packages = with pkgs; [
    htop
    fzf
    fd
    ripgrep
    fastfetch
    inetutils
  ];

  programs = {
    home-manager.enable = true;

    bash.enable = true;
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "junkfood";
        plugins = [
          "tmux"
          "git"
          "ssh"
          "fzf"
        ];
      };
    };

    tmux = {
      enable = true;
      keyMode = "vi";
      shortcut = "a";
      mouse = true;
    };

    git = {
      enable = true;
      extraConfig = {
        user.name = "Ben Matthies";
        user.email = "matthiesbe@gmail.com";
        init.defaultBranch = "main";
      };
    };

    # Enable GitHub credential helper.
    gh.enable = true;
  };

  # Install GitHub token from sops.
  home.file.".config/gh/hosts.yml".source = config.lib.file.mkOutOfStoreSymlink sops.secrets."gh/hosts.yml".path;

  home.stateVersion = "24.11";
}
