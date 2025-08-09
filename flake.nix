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
            cp --preserve=mode pre-commit-hook .git/hooks/pre-commit
          '';
        };

      # Configure `nix fmt`.
      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations.wunstpc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          ./nixos/modules
          ./nixos/systems/wunstpc
          ./modules/allow-unfree.nix
        ];
      };
    };
}
