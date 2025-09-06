{
  description = "Ben's NixOS + home-manager + sops-nix configuration";

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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
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

      nixosConfigurations.wunstpc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          self.nixosModules.default
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.default

          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [
                self.overlays.default
              ];

              # Modules are for reusable stuff, my personal config goes here.
              # My window manager.
              bm-profiles.workstation.windowManager = "plasma6";

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
              services.xserver.xkb = {
                layout = "de";
                variant = "";
                options = "caps:escape";
              };

              # Declare secrets.
              sops = {
                defaultSopsFile = ./secrets.wunstpc.yml;
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

                  home.stateVersion = config.system.stateVersion;
                };
              };
            }
          )

          ./nixos/systems/wunstpc
          ./allow-unfree.nix
        ];
      };
    };
}
