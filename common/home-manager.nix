{ ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.users.guillaume = import ../home;
}
