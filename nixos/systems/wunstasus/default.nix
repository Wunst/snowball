{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "wunstasus";

  # Declarative disk layout.
  bm-disko = {
    enable = true;
    device = "/dev/nvme0n1";
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  bm-profiles = {
    workstation.enable = true;
    gaming.enable = true;
  };

  # Wireguard VPN to my home network.
  sops.secrets."wireguard/privateKey" = { };
  networking.wg-quick.interfaces.wg0 = {
    address = [ "192.168.99.9/24" ];
    dns = [ "192.168.98.2" ];

    privateKeyFile = config.sops.secrets."wireguard/privateKey".path;

    peers = [
      {
        publicKey = "C3UEz3gojSQKnorZMzExarpQ5E7Vx3Hcx1KWMadAVlk=";
        allowedIPs = [ "192.168.98.0/23" ];
        endpoint = "toenderup.no-ip.org:51820";
        persistentKeepalive = 25;
      }
    ];
  };

  system.stateVersion = "25.05";
}
