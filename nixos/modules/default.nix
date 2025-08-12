{ ... }:
{
  imports = [
    ./roles/workstation.nix
    ./roles/gaming.nix
    ./users/ben
    ./services/docker.nix
    ./services/openssh.nix
    ./services/pipewire.nix
  ];
}
