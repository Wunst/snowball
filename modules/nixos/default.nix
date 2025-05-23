{ config, pkgs, ... }: {
  imports = [
    ./graphical
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 5; 
      };
    };
    plymouth.enable = true;
    plymouth.theme = "breeze";
    initrd.systemd.enable = true; 
  };

  nix = {
    gc.automatic = true;
    gc.dates = "weekly";
    channel.enable = false;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  networking.networkmanager.enable = true;

  i18n.defaultLocale = "de_DE.UTF-8";

  console = {
    keyMap = "de";
    font = "eurlatgr";
  };

  time.timeZone = "Europe/Berlin";

  programs = {
    zsh.enable = true;
  };

  users.users.ben = {
    isNormalUser = true;
    description = "Ben";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "docker"
      "dialout"
    ];
    openssh.authorizedKeys.keys = [
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBHCrM09d4P9jT4bSwAKREEKfOFfX905hCIer/7SIGSB4GIFGvJ130efh1K7gpHKjLgiooPrQKzb7ljBRT1TGZ60AAAAEc3NoOg=="
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBH95/J3jLiUrKVVj9NfwChj8UdyEeh5KtM1xLZ7+K0NKC9eEG/VJyYf/0j1WK4NDFEshj6cIY2Iq9VTVYESpnxwAAAAEc3NoOg=="
    ];
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Pass secrets to home-manager.
    extraSpecialArgs = {
      sops = config.sops;
    };
    users.ben = import ../home-manager;
  };

  services = {
    fwupd.enable = true;
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
