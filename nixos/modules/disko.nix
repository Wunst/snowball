{ config, lib, ... }:
let
  cfg = config.bm-disko;
in
{
  options.bm-disko = with lib; {
    enable = mkEnableOption "my Disko disk layout (EFI system partition, followed by btrfs on LUKS)";

    device = mkOption {
      description = "Which disk to install on, e.g. `/dev/nvme0n1`, `/dev/sda`…";
      type = types.str;
    };
  };

  config = {
    disko.devices.disk.main = {
      device = cfg.device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            # EFI system partition.
            type = "EF00";

            size = "4G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          luks = {
            size = "100%";
            content = {
              # Interactive password entry on `disko-install`.
              type = "luks";
              name = "crypted";
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/@root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                    ];
                  };

                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                    ];
                  };

                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
