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
      tapes = pkgs.callPackage ./nix/package.nix {};
    in {
      packages = {
        default = tapes;
        inherit tapes;
      };
    })
    // {
      overlays = {
        default = final: prev: {
          tapes = self.packages.${prev.stdenv.hostPlatform.system}.tapes;
        };
        tapes = self.overlays.default;
      };
    };
}
