{ ... }: {
  imports = [
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./desktop.nix
    ./audio.nix
    ./security.nix
    ./virtualisation.nix
    ./fonts.nix
    ./udev.nix
    ./users.nix
    ./home-manager.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "guillaume" ];
}
