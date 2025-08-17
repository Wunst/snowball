{ ... }:
{
  nixpkgs.overlays = [
    (import ../overlays/spotify-spotx.nix)
  ];
}
