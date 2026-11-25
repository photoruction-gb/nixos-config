{ config, ... }: {
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

    # On-access scanning via fanotify. clamonacc forwards file opens in the
    # watched paths to clamd and blocks the open until the scan completes.
    # Detections are surfaced as desktop notifications by home/clamav.nix.
    clamonacc.enable = true;
    daemon.settings = let
      home = config.users.users.guillaume.home;
    in {
      # Only watch where external files usually land; watching all of $HOME
      # (caches, browser profiles, dev builds) costs too much CPU on carbonx1.
      OnAccessIncludePath = [
        "${home}/Downloads"
        "${home}/Desktop"
        "/tmp"
      ];
      # Deny access to infected files instead of only logging them.
      OnAccessPrevention = true;
      # Default is 5M, which skips most downloaded archives and installers.
      OnAccessMaxFileSize = "100M";
    };
    # scanner = {
    #   enable = true;
    #   interval = "*-*-* 22:00:00";
    # };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
