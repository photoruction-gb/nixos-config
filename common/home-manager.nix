{ inputs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.sharedModules = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
    inputs.noctalia-v5.homeModules.default
  ];
  home-manager.users.guillaume = import ../home;
}
