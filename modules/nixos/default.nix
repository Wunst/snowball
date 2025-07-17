{ config, pkgs, ... }: {
  imports = [
    ./graphical
    ./wireshark.nix
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
      "wireshark"
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

  system.activationScripts.symlink-requestkey = ''
      if [ ! -d /sbin ]; then
        mkdir /sbin
      fi
      ln -sfn /run/current-system/sw/bin/request-key /sbin/request-key
    '';
    # request-key expects a configuration file under /etc
    environment.etc."request-key.conf" = {
      text = let
        upcall = "${pkgs.cifs-utils}/bin/cifs.upcall";
        keyctl = "${pkgs.keyutils}/bin/keyctl";
      in ''
        #OP     TYPE          DESCRIPTION  CALLOUT_INFO  PROGRAM
        # -t is required for DFS share servers...
        create  cifs.spnego   *            *             ${upcall} -t %k
        create  dns_resolver  *            *             ${upcall} %k
        # Everything below this point is essentially the default configuration,
        # modified minimally to work under NixOS. Notably, it provides debug
        # logging.
        create  user          debug:*      negate        ${keyctl} negate %k 30 %S
        create  user          debug:*      rejected      ${keyctl} reject %k 30 %c %S
        create  user          debug:*      expired       ${keyctl} reject %k 30 %c %S
        create  user          debug:*      revoked       ${keyctl} reject %k 30 %c %S
        create  user          debug:loop:* *             |${pkgs.coreutils}/bin/cat
        create  user          debug:*      *             ${pkgs.keyutils}/share/keyutils/request-key-debug.sh %k %d %c %S
        negate  *             *            *             ${keyctl} negate %k 30 %S
      '';
    };
  environment.systemPackages = with pkgs; [
    cifs-utils
    keyutils
  ];
}
