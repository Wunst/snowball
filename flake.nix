{
  description = "Ben's NixOS + home-manager configuration";

  inputs = {
    # nixpkgs, only fetching latest nixos-unstable and no commit history, saving downlaod speed.
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... }: let
    # Used for the devShell.
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    devShells.${system}.default = with pkgs; mkShell {
      buildInputs = [
        just
        nil # Nix language server.
      ];
    };

    nixosConfigurations.wunstpc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/systems/wunstpc
      ];
    };
  };
}

