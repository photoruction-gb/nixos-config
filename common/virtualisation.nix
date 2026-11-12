{ ... }: {
  virtualisation = {
    containers = {
      enable = true;

      # Rendered to /etc/containers/containers.conf.d/00-nixos.conf.
      containersConf.settings = {
        # Fixed upstream DNS so containers keep resolving after switching networks (home/office).
        # aardvark-dns still answers container names and forwards the rest to these.
        containers.dns_servers = ["1.1.1.1" "8.8.8.8"];
      };
    };

    docker = {
      enable = false;
    };
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
