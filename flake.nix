{
  description = "Ben's NixOS + home-manager + sops-nix + disko configuration";

  inputs = {
    # I previously used a `git+https` URL to shallow clone here, but the `github` URL syntax already uses the tarball to speed up downloads.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      disko,
      ...
    }:
    let
      # Used for the development environment.
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      # Development shell for this config.
      # Run `nix develop` for a bash shell, or `nix develop -c zsh`, `fish`… for your preferred shell.
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          just
          nil
          sops
          age
          age-plugin-fido2-hmac
          ssh-to-age
        ];

        shellHook = ''
          echo Installing pre-commit hook…
          cp --preserve=mode git/hooks/pre-commit .git/hooks/pre-commit
        '';
      };

      # Configure `nix fmt` command.
      formatter.x86_64-linux = pkgs.nixfmt-tree;

      # Export NixOS modules. Someone might want to use those.
      nixosModules.default = import ./nixos/modules;
      homeManagerModules.default = import ./home-manager/modules;

      # My custom or modified packages.
      packages = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        import ./pkgs pkgs
      );

      # … and again as an overlay …
      overlays.default = final: prev: import ./pkgs prev;

      nixosConfigurations =
        let
          mkSystem =
            { system, hostname }:
            nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                self.nixosModules.default
                home-manager.nixosModules.home-manager
                sops-nix.nixosModules.default
                disko.nixosModules.disko

                (
                  { config, pkgs, ... }:
                  {
                    nixpkgs.overlays = [
                      self.overlays.default
                    ];

                    # Modules are for reusable stuff, my personal config goes here.
                    # Localization.
                    i18n = {
                      # English language locale with metric units, A4 paper, week starting on Monday…
                      defaultLocale = "en_DK.UTF-8";
                      extraLocaleSettings = {
                        # Euro.
                        LC_MONETARY = "de_DE.UTF-8";
                      };
                    };

                    time.timeZone = "Europe/Berlin";

                    # Configure keyboard layout.
                    console.useXkbConfig = true;
                    services = {
                      xserver.xkb = {
                        layout = "de";
                        variant = "";
                        options = "caps:escape";
                      };

                      # My window manager.
                      bm-graphical = {
                        displayManager = "sddm";
                        windowManager = "plasma6";
                      };
                    };

                    # Declare secrets.
                    sops = {
                      defaultSopsFile = ./secrets.${hostname}.yml;
                      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
                      secrets = {
                        hashedPassword = {
                          neededForUsers = true;
                        };
                        githubToken = {
                          owner = "ben";
                        };
                        "gpg/privateKeys/015E6B992731C5B8" = {
                          # Private key for matthiesbe@gmail.com.
                          owner = "ben";
                        };
                        "gpg/privateKeys/995B0CAE47D0D637" = {
                          # Private key for ben.matthies@stu.uni-kiel.de.
                          owner = "ben";
                        };
                      };
                    };

                    # User configuration.
                    # Add Nix profiles to zsh, and zsh to the list of allowed shells.
                    programs.zsh.enable = true;

                    users.users.ben = {
                      isNormalUser = true;
                      description = "Ben";
                      shell = pkgs.zsh;
                      extraGroups = [
                        "wheel"
                        "networkmanager"
                        "docker"
                      ];
                      openssh.authorizedKeys.keyFiles = [
                        ./authorized_keys
                      ];
                      hashedPasswordFile = config.sops.secrets.hashedPassword.path;
                    };

                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;

                      # Home configuration.
                      users.ben = {
                        imports = [
                          self.homeManagerModules.default
                        ];

                        programs = {
                          # TODO: Only enable on targets where it's needed.
                          gpg = {
                            enable = true;

                            # The option is called `publicKeys`, but works for `privateKeys` as well apparently?
                            publicKeys = [
                              {
                                source = config.sops.secrets."gpg/privateKeys/015E6B992731C5B8".path;
                                trust = "full";
                              }
                              {
                                source = config.sops.secrets."gpg/privateKeys/995B0CAE47D0D637".path;
                                trust = "full";
                              }
                            ];
                          };

                          bm-git = {
                            enable = true;
                            userName = "Ben Matthies";
                            userEmail = "matthiesbe@gmail.com";
                            githubTokenFile = config.sops.secrets.githubToken.path;
                          };
                          bm-neovim = {
                            enable = true;
                            defaultEditor = true;
                          };
                        };

                        # Mail accounts.
                        accounts = {
                          email.accounts = {
                            "1 personal" = {
                              primary = true;
                              address = "matthiesbe@gmail.com";
                              realName = "Ben Matthies";
                              flavor = "gmail.com";
                              gpg = {
                                key = "015E6B992731C5B8";
                                encryptByDefault = true;
                                signByDefault = true;
                              };
                              signature = {
                                showSignature = "append";
                                delimiter = "~*~-~*~-~*~-~*~";
                                text = ''
                                  Ben Matthies
                                  -
                                  Sie können mir mit OpenPGP verschlüsselte Nachrichten schicken. Sie sollten
                                  Ihre Nachrichten verschlüsseln, wenn Sie Bedenken haben, dass Ihr oder mein 
                                  Mailanbieter (Google Mail) Ihre Nachricht mitliest.
                                  Hilfe für Ihr Mailprogramm: https://www.openpgp.org/software/
                                  Mein Public Key: https://keys.openpgp.org/search?q=matthiesbe@gmail.com
                                  Fingerprint: 55C7 85F0 91A0 9C19 B096 53A5 015E 6B99 2731 C5B8

                                  Damit ich Ihnen verschlüsselt antworten kann, müssen Sie Ihren eigenen (von
                                  Ihnen erzeugten) Public Key entweder mitschicken oder auf keys.openpgp.org 
                                  registrieren. '';
                              };
                              thunderbird = {
                                enable = true;
                                settings = id: {
                                  # More sane archive location than Gmail "All messages"
                                  "mail.identity.id_${id}.archive_folder" = "imap://matthiesbe%40gmail.com@imap.gmail.com/Archiv";
                                };
                              };
                            };

                            "2 school" = {
                              address = "ben.matthies@mps-ki.de";
                              realName = "Ben Matthies";
                              userName = "ben.matthies";
                              smtp = {
                                host = "mps-ki.de";
                                port = 465;
                              };
                              imap = {
                                host = "mps-ki.de";
                                port = 993;
                              };
                              signature = {
                                showSignature = "append";
                                text = ''
                                  Ben Matthies
                                  Admin AG
                                  Max-Planck-Schule Kiel
                                  Winterbeker Weg 1, 24114 Kiel '';
                              };
                              thunderbird.enable = true;
                            };

                            "3 uni" = {
                              address = "ben.matthies@stu.uni-kiel.de";
                              realName = "Ben Matthies";
                              userName = "stu249890";
                              gpg = {
                                key = "995B0CAE47D0D637";
                                encryptByDefault = true;
                                signByDefault = true;
                              };
                              smtp = {
                                host = "smtps.mail.uni-kiel.de";
                                port = 465;
                              };
                              imap = {
                                host = "imap.mail.uni-kiel.de";
                                port = 993;
                              };
                              signature = {
                                showSignature = "append";
                                text = ''
                                  Ben Matthies
                                  Student der Physik (1Ba)
                                  3. Fachsemester
                                '';
                              };
                              thunderbird.enable = true;
                            };
                          };

                          calendar.accounts = {
                            "1 personal" = {
                              primary = true;
                              remote = {
                                type = "caldav";
                                url = "https://apidata.googleusercontent.com/caldav/v2/matthiesbe%40gmail.com/events/";
                                userName = "matthiesbe@gmail.com";
                              };
                              thunderbird.enable = true;
                            };

                            "2 holidays" = {
                              remote = {
                                type = "caldav";
                                url = "https://apidata.googleusercontent.com/caldav/v2/chiispr5e9mm2rh3d1nmoqb4c5sk0pridtqn0bjm5phm2r35dpi62shectnmuprcckn66rrd%40virtual/events/";
                                userName = "matthiesbe@gmail.com";
                              };
                              thunderbird = {
                                enable = true;
                                color = "#00ff66";
                              };
                            };
                          };
                        };

                        home.stateVersion = config.system.stateVersion;
                      };
                    };
                  }
                )

                ./nixos/systems/${hostname}
                ./allow-unfree.nix
              ];
            };
        in
        {
          wunstpc = mkSystem {
            system = "x86_64-linux";
            hostname = "wunstpc";
          };

          wunstasus = mkSystem {
            system = "x86_64-linux";
            hostname = "wunstasus";
          };
        };
    };
}
