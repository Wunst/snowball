# Another attempt at NixOS configuration
![os:nixos](https://img.shields.io/badge/os-nixos-purple?style=flat-square&logo=nixos&logoColor=white)
![wm:plasma6](https://img.shields.io/badge/wm-plasma6-blue?style=flat-square&logo=kde&logoColor=white)
![shell:zsh](https://img.shields.io/badge/shell-zsh-red?style=flat-square&logo=zsh&logoColor=white)
![editor:neovim](https://img.shields.io/badge/editor-neovim-green?style=flat-square&logo=neovim&logoColor=white)
![secrets:sops-nix](https://img.shields.io/badge/secrets-sops--nix-orange?style=flat-square&logo=keepassxc&logoColor=white)

This is not the best, most idiomatic, or most complete NixOS system, but it's mine, take it or leave it.

## Design principles
- **Track and configure as much as I can.** In an ideal world, I'd just boot an install stick, switch to this
  config, and have my editor, browser, SSH config, and e-mail accounts with PGP set up and ready to use.
- Do as much as possible in the `home-manager`, i. e. user config.
  This makes the config more easily portable to non-NixOS targets or systems where I don't have root access.
- Have little external dependencies: I only import `nixpkgs`, `home-manager` (I don't want to write my own
  user config framework), and `sops-nix` (not rolling my own crypto ;)). No pre-made styling or configuration
  frameworks (`stylix`, `nixvim` et al.)

## Try my system
To Do: Instructions to make this portable.

