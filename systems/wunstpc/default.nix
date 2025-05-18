{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  services = {
    btrfs.autoScrub = {
      enable = true; 
      interval = "monthly";
    };
    xserver.videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia.open = false; # GTX 1050Ti works better with unfree drivers.

  system.stateVersion = "24.11";
}
