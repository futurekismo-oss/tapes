{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
}: let
  version = "0.1.10-beta.1";
in
  stdenv.mkDerivation {
    pname = "tapes-bin";
    inherit version;

    src = fetchurl {
      url = "https://github.com/futurekismo-oss/tapes/releases/download/v${version}/tapes-x86_64-unknown-linux-gnu";
      hash = "sha256-PUvzBIQblbcWvZJWgzi8sd377pOYkNsTCs4+YybcHf0=";
    };

    nativeBuildInputs = [autoPatchelfHook];
    buildInputs = [stdenv.cc.cc.lib];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 "$src" "$out/bin/tapes"
      runHook postInstall
    '';

    meta = {
      description = "Swap your whole rice in one command. Eject it with one more. Atomic dotfiles switching for Linux (prebuilt binary).";
      homepage = "https://github.com/futurekismo-oss/tapes";
      license = with lib.licenses; [
        gpl3Only
      ];
      mainProgram = "tapes";
      platforms = ["x86_64-linux"];
    };
  }
