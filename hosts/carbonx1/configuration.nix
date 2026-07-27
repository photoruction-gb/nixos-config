{ config, pkgs, lib, ... }: {
  imports = [
    ../../common
  ];

  nixpkgs.config.permittedInsecurePackages = [
  ];

  boot.initrd.luks.devices."luks-6ab574dc-dbf0-4a1d-b8a3-98a9e02fa1df".device = "/dev/disk/by-uuid/6ab574dc-dbf0-4a1d-b8a3-98a9e02fa1df";

  boot.extraModprobeConfig = ''
    options iwlwifi 11n_disable=1
  '';

  # Enable networking
  networking.hostName = "carbonx1";
  networking.extraHosts = ''
    127.0.0.1 minio-localhost
    127.0.0.1 build.local
    127.0.0.1 build.auth.local
    127.0.0.1 auth.build.local
    127.0.0.1 ppmv-lambda
    127.0.0.1 photoruction-minio
    127.0.0.1 photoruction-sqs
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
