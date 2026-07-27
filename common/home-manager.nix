{ inputs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.sharedModules = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
  ];
  home-manager.users.guillaume = import ../home;
}
