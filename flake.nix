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
    { nixpkgs, ... }:
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
    };
}
