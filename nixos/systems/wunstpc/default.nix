{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "wunstpc";
  system.stateVersion = "24.11";

  # Add my system role.
  roles.workstation.enable = true;

  roles.gaming.enable = true;

  # TODO: Refactor into a module
  # btrfs config. Generated hardware configuration includes btrfs subvolumes, but no other mount options.
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
  };
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  # TODO: Proprietary nvidia drivers (necessary?)
}
