{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "wunstasus";
  system.stateVersion = "25.05";

  # Add my system role.
  roles.workstation.enable = true;

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

  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };

    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };

    blueman.enable = true;
  };
}
