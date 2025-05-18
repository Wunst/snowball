switch:
  git add .
  sudo nixos-rebuild switch --flake . 
  git commit

edit-secrets:
  SOPS_AGE_KEY="$(cat identity.txt)" sops secrets/secrets.yaml
