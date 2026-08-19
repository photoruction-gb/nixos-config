let
  version = import ./noctalia-version.nix;
in {
  imports = [
    (if version == "v5" then ./noctalia-v5.nix else ./noctalia-v4.nix)
  ];
}
