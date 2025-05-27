{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "hpeqlp";

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  services.btrfs.autoScrub = {
    enable = true; 
    interval = "monthly";
  };

  system.stateVersion = "24.11";
}
