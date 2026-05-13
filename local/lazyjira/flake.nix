{
  description = "A lazy Jira TUI client";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        srcInfo = {
          owner = "jonbito";
          repo = "lazyjira";
          rev = "v0.2.0";
          hash = "sha256-+kWoCBvOwLPmvKUwfshZIKwyND5bDqwKerJEfPdo61c=";
        };
        src = pkgs.fetchFromGitHub srcInfo;
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "lazyjira";
          version = srcInfo.rev;

          inherit src;

          cargoLock.lockFile = "${src}/Cargo.lock";

          nativeBuildInputs = [ pkgs.pkg-config ];
          buildInputs = [ pkgs.openssl pkgs.libsecret ];
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.default ];
          packages = [ pkgs.rust-analyzer pkgs.cargo pkgs.rustc ];
        };
      }
    );
}
