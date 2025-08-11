{ ... }:
{
  imports = [
    ./roles/workstation.nix
    ./roles/gaming.nix
    ./users/ben
    ./services/openssh.nix
    ./services/pipewire.nix
  ];
}
