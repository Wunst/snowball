{ config, lib, ... }:
let
  cfg = config.roles.workstation;
in
{
  options.roles.workstation.enable = lib.mkEnableOption "Enable workstation";

  config = lib.mkIf cfg.enable {
    # TODO: Refactor into modules.
    boot.loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    networking.networkmanager.enable = true;

    # Localization.
    time.timeZone = "Europe/Berlin";
    i18n = {
      # English language, continental European measurements, calendar…
      defaultLocale = "en_DK.UTF-8";
      extraLocaleSettings = {
        # Euro.
        LC_MONETARY = "de_DE.UTF-8";
      };
    };

    services = {
      fwupd.enable = true;

      my-openssh.enable = true;
      my-pipewire.enable = true;

      my-printing.enable = true;

      # Enable docker host for development. Prune modules regularly.
      my-docker = {
        enable = true;
        prune = "volumes";
      };

      # TODO: Refactor into a module
      xserver = {
        enable = true;
        xkb = {
          layout = "de";
          variant = "";
          options = "caps:escape";
        };
      };

      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
    };

    users = {
      ben.enable = true;
      users.root.hashedPassword = "!"; # Lock the root account.
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.ben = {
        imports = [
          ../../../home-manager/modules
          ../../../home-manager/users/ben.nix
        ];
        roles.workstation.enable = true;
        home.stateVersion = config.system.stateVersion;
      };
    };
  };
}
