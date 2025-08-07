switch system="":
  git add .
  sudo nixos-rebuild switch --flake .#{{system}}
  git commit -v

check:
  git add .
  nix flake check

