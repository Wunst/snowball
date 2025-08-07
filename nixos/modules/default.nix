{ ... }:
{
  imports = [
    ./roles/workstation.nix
    ./users/ben
    ./services/openssh.nix
    ./services/pipewire.nix
  ];
}
