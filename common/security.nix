{ ... }: {
  security.doas = {
    enable = true;
    extraRules = [
      {
        groups = ["wheel"];
        persist = true;
        keepEnv = true;
      }
    ];
  };
  security.rtkit.enable = true;
  security.polkit = {
    enable = true;
  };

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    # scanner = {
    #   enable = true;
    #   interval = "*-*-* 22:00:00";
    # };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
