{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    envelope = {
      url = "path:./local/envelope";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    claude-code = {
      url = "path:./local/claude-code";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, home-manager, envelope, claude-code, ... }: {
    nixosConfigurations.carbonx1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit envelope claude-code; };
      modules = [
        home-manager.nixosModules.home-manager
        ./hardware-configuration.nix
        ./carbonx1.nix
      ];
    };
  };
}
