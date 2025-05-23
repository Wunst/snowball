switch:
  git add .
  sudo nixos-rebuild switch --flake . 
  git commit

rollback:
  sudo nixos-rebuild switch --rollback

edit-secrets:
  SOPS_AGE_KEY="$(cat identity.txt)" sops secrets/secrets.yaml
