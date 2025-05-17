{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { nixpkgs, home-manager, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    devShells.${system}.default = with pkgs; mkShell {
      buildInputs = [
        just
        sops
        ssh-to-age
      ];
    };

    nixosConfigurations = let
      mkSystem = system: hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          home-manager.nixosModules.home-manager
        ];
      };
    in {
      wunstpc = mkSystem "x86_64-linux" "wunstpc";
    };
  };
}
