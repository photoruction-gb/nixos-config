{
  description = "A modern environment variables manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        srcInfo = {
          owner = "mattrighetti";
          repo = "envelope";
          rev = "0.7.1";
          hash = "sha256-iV0HHZQbTOvEkfVM+tckM3cAkWE2SPq4GpyvCLCdMkE=";
        };
        src = pkgs.fetchFromGitHub srcInfo;
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "envelope";
          version = srcInfo.rev;

          inherit src;

          cargoLock.lockFile = "${src}/Cargo.lock";

          nativeBuildInputs = [ pkgs.pkg-config ];
          buildInputs = [ pkgs.sqlite ];
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.default ];
          packages = [ pkgs.rust-analyzer pkgs.cargo pkgs.rustc ];
        };
      }
    );
}
