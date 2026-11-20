{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
}: let
  cargoToml = fromTOML (builtins.readFile ../Cargo.toml);
  version = cargoToml.package.version;
in
  stdenv.mkDerivation {
    pname = "tapes-bin";
    inherit version;

    src = fetchurl {
      url = "https://github.com/futurekismo-oss/tapes/releases/download/v${version}/tapes-x86_64-unknown-linux-gnu";
      hash = "sha256-49dzbr5HhUbK5mdY8LDzV63qXljfSVe/LFIPmRws4RA=";
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
