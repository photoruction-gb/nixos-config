{ ... }: {
  # Matches kuma-giyomu/nixos-system-flake's home/noctilia.nix.
  programs.noctalia-shell = {
    enable = true;
    settings = {
      # configure noctalia here; defaults will
      # be deep merged with these attributes.
      dock = {
        enabled = true;
        displayMode = "auto_hide";
      };
      bar = {
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "SidePanelToggle";
              useDistroLogo = true;
            }
            {
              id = "SystemMonitor";
            }
            {
              id = "MediaMini";
            }
            {
              id = "ActiveWindow";
            }
          ];
          center = [
            {
              id = "Workspace";
            }
          ];
          right = [
            {
              id = "Tray";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "Battery";
              alwaysShowPercentage = true;
              warningThreshold = 30;
            }
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              useMonospacedFont = true;
            }
          ];
        };
      };
      colorSchemes.predefinedScheme = "Catppuccin";
      general = {
        radiusRatio = 0.2;
      };
    };
  };
}
