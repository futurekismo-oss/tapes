{
  rustPlatform,
  lib,
  mold,
}: let
  cargoToml = builtins.fromTOML (builtins.readFile ../Cargo.toml);
in
  rustPlatform.buildRustPackage {
    pname = "tapes";
    version = cargoToml.package.version;

    src = lib.cleanSource ../.;

    cargoLock.lockFile = ../Cargo.lock;

    nativeBuildInputs = [
      mold
    ];

    env.RUSTC_WRAPPER = "";

    meta = {
      description = "Swap your whole rice in one command. Eject it with one more. Atomic dotfiles switching for Linux.";
      homepage = "https://github.com/futurekismo-oss/tapes";
      license = with lib.licenses; [
        gpl3Only
      ];
      mainProgram = "tapes";
      platforms = lib.platforms.linux;
    };
  }
