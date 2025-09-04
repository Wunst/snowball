{
  lib,
  spotify,
  util-linux,
  perl,
  unzip,
  zip,
  curl,
  fetchurl,
}:
let
  spotx = fetchurl {
    url = "https://raw.githubusercontent.com/SpotX-Official/SpotX-Bash/3b1f1ef6dc215dc12d88b0848c264dfe890411a7/spotx.sh";
    hash = "sha256-+2byFxDSFdahDI51KK2LYaF9jb0lfE77mHRQxFUFbto=";
  };
in
spotify.overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [
    util-linux
    perl
    unzip
    zip
    curl
  ];

  unpackPhase =
    builtins.replaceStrings
      [ "runHook postUnpack" ]
      [
        ''
          patchShebangs --build ${spotx}
          runHook postUnpack
        ''
      ]
      old.unpackPhase;

  installPhase =
    builtins.replaceStrings
      [ "runHook postInstall" ]
      [
        ''
          bash ${spotx} -f -P "$out/share/spotify"
          runHook postInstall
        ''
      ]
      old.installPhase;

  meta = with lib; {
    description = "Spotify with adblock by SpotX-Bash";
    homepage = "https://github.com/SpotX-Official/SpotX-Bash";
    license = licenses.unfree;
    maintainers = [ ];
    mainProgram = "spotify";
    platforms = platforms.linux;
  };
})
