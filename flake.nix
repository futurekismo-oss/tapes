{
  description = "Tapes v2 - Atomic per-target dotfile switcher";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      tapes-src = pkgs.callPackage ./nix/package.nix {};
      tapes-bin = pkgs.callPackage ./nix/bin.nix {};
      useBin =
        system == "x86_64-linux"
        && tapes-bin.version == tapes-src.version
        && pkgs.lib.versionAtLeast pkgs.glibc.version "2.39";
    in {
      packages =
        {
          default =
            if useBin
            then tapes-bin
            else tapes-src;
          tapes = tapes-src;
          inherit tapes-src;
        }
        // pkgs.lib.optionalAttrs (system == "x86_64-linux") {
          inherit tapes-bin;
        };
    })
    // {
      overlays = {
        default = final: prev: {
          tapes = self.packages.${prev.stdenv.hostPlatform.system}.default;
        };
        tapes = self.overlays.default;
      };
    };
}
