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
    { self, nixpkgs, ... }:
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

      nixosConfigurations.wunstpc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          self.nixosModules.default
          {
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
            services.xserver.xkb = {
              layout = "de";
              variant = "";
              options = "caps:escape";
            };

            # User configuration.
            users.users.ben = {
              isNormalUser = true;
              description = "Ben";
              extraGroups = [
                "wheel"
                "networkmanager"
                "docker"
              ];
              openssh.authorizedKeys.keyFiles = [
                ./authorized_keys
              ];
            };
          }
          ./nixos/systems/wunstpc
        ];
      };
    };
}
