{ pkgs, ... }: {
  imports = [
    ./gaming.nix
  ];

  security.rtkit.enable = true;

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "de,us";
        variant = "";
        options = "caps:escape";
      };
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };

    displayManager.sddm.enable = true;

    desktopManager.plasma6.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        hplipWithPlugin
      ];
    };
  };
}
