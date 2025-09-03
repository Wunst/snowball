{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "wunstpc";

  bm-profiles = {
    workstation.enable = true;
    gaming.enable = true;
  };

  # btrfs config.
  # Generated hardware configuration contains only subvolumes, but no other mount options.
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

  # Proprietary nvidia drivers. Free drivers allegedly work well on newer cards, but not my 1050Ti.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;

  system.stateVersion = "24.11";
}
