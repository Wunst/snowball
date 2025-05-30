{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { nixpkgs, home-manager, sops-nix, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    devShells.${system}.default = with pkgs; mkShell {
      buildInputs = [
        nil
        just
        sops
        ssh-to-age
        age-plugin-fido2-hmac
      ];
    };

    nixosConfigurations = let
      mkSystem = system: hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          {
            nixpkgs.overlays = import ./overlays;
          }

          ./modules/nixos
          ./systems/${hostname}
          ./sops.nix
          ./allowUnfree.nix
        ];
      };
    in {
      wunstpc = mkSystem "x86_64-linux" "wunstpc";
      hpeqlp = mkSystem "x86_64-linux" "hpeqlp";
    };
  };
}
