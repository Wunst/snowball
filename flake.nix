{
  description = "Ben's NixOS + home-manager configuration";

  inputs = {
    # I previously used a `git+https` URL to shallow clone here, but the `github` URL syntax already uses the tarball to speed up downloads.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux"; # Used for the devShell.
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      devShells.${system}.default =
        with pkgs;
        mkShell {
          buildInputs = [
            just
            nil # Nix language server.
          ];
          shellHook = ''
            echo Installing pre-commit hook…
            cp --preserve=mode git/hooks/pre-commit .git/hooks/pre-commit
          '';
        };

      # Configure `nix fmt`.
      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations = 
        let
          mkSystem = { system, hostName }: nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              home-manager.nixosModules.home-manager
              ./nixos/modules
              ./nixos/systems/${hostName}
              ./modules/allow-unfree.nix
              ./modules/overlays.nix
            ];
          };
        in {
          wunstpc = mkSystem {
            system = "x86_64-linux";
            hostName = "wunstpc";
          };
        };
    };
}
