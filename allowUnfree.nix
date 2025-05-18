{ lib, ... }: {
  nixpkgs.config.allowUnfreePredicate =
    p: builtins.elem (lib.getName p) [
      "nvidia-x11"
      "nvidia-settings"
    ];
}
