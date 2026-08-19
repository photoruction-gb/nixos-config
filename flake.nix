{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    niri.url = "github:sodiboo/niri-flake";
    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # v5: from-scratch C++/OpenGL-ES rewrite, still in Beta upstream. Kept
    # alongside legacy-v4 so home/noctalia-version.nix can toggle between them
    # (see memory: noctalia_v5_trial).
    noctalia-v5 = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    markdown-reader = {
      url = "github:leboiko/markdown-reader";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.carbonx1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        home-manager.nixosModules.home-manager
        ./hosts/carbonx1/hardware-configuration.nix
        ./hosts/carbonx1/configuration.nix
      ];
    };
  };
}
