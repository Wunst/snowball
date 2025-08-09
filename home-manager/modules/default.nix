{ ... }:
{
  imports = [
    ./roles/workstation.nix
    ./programs/zsh.nix
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/firefox.nix
    ./programs/thunderbird.nix
  ];
}
