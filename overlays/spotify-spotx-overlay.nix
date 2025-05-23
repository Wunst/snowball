final: prev: let
  spotx = prev.fetchurl {
    url = "https://raw.githubusercontent.com/SpotX-Official/SpotX-Bash/c39047718da0206199ba83df28fc41a235b38f86/spotx.sh";
    hash = "sha256-zozR1ODx9yWH97m1VOl+sijEY+HhBQ2LAToR1ro25/Y=";
  };
in {
  spotify = prev.spotify.overrideAttrs (old: {
    nativeBuildInputs =
      old.nativeBuildInputs
      ++ (with prev; [
          util-linux
          perl
          unzip
          zip
          curl
      ]);

    unpackPhase = builtins.replaceStrings [ "runHook postUnpack" ] [
      ''
        patchShebangs --build ${spotx}
        runHook postUnpack
      ''
    ] old.unpackPhase;
    
    installPhase = builtins.replaceStrings [ "runHook postInstall" ] [
      ''
        bash ${spotx} -f -P "$out/share/spotify"
        runHook postInstall
      ''
    ] old.installPhase;
  });
}
