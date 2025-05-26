{ pkgs, ... }: {
  home.packages = with pkgs; [
    hyperrogue
    prismlauncher
    (retroarch.withCores (c: with c; [
      mesen
      bsnes
      dolphin
      scummvm
    ]))
  ];
}
