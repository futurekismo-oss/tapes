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
      hash = "sha256-PUvzBIQblbcWvZJWgzi8sd377pOYkNsTCs4+YybcHf0=";
    };

    nativeBuildInputs = [autoPatchelfHook];
    buildInputs = [stdenv.cc.cc.lib];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 "$src" "$out/bin/tapes"
      # Upstream links with mold, which merges GNU_PROPERTY_X86_ISA_1_NEEDED (x86-64-v3) from
      # runtime-dispatched SIMD crates (memchr) into .note.gnu.property, blocking execution on
      # x86-64-v1/v2 CPUs and VMs. Reset the ISA requirement mask to x86-64-baseline (0x01).
      if objdump -h "$out/bin/tapes" 2>/dev/null | grep -q '\.note\.gnu\.property'; then
        printf '\x04\x00\x00\x00\x10\x00\x00\x00\x05\x00\x00\x00GNU\x00\x02\x80\x00\xc0\x04\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00' > note.bin
        objcopy --update-section .note.gnu.property=note.bin "$out/bin/tapes"
        rm -f note.bin
      fi
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
