edit-secrets system="$(hostname)":
  SOPS_AGE_KEY=$(age-plugin-fido2-hmac -m) sops secrets.{{system}}.yml

check:
  git add .
  nix flake check

switch system="":
  git add .
  sudo nixos-rebuild switch --flake .#{{system}}
  git commit -v
