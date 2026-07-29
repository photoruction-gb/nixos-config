{ config, ... }:
let
  wallpaperPath = "${config.home.homeDirectory}/Pictures/Wallpapers/PhotoructionDesktopPicture.png";
in {
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
              compactMode = false;
              showCpuUsage = true;
              showCpuTemp = true;
              showMemoryUsage = true;
              showMemoryAsPercent = true;
              showDiskUsage = true;
              showDiskUsageAsPercent = true;
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

  # The currently selected wallpaper lives in ~/.cache/noctalia/wallpapers.json
  # (a cache file the app reads/writes directly via a JsonAdapter), not in
  # settings.json. So a `wallpaper` key under programs.noctalia-shell.settings
  # has no effect here — it must be declared as xdg.cacheFile instead.
  xdg.cacheFile."noctalia/wallpapers.json".text = builtins.toJSON {
    wallpapers = {
      "eDP-1" = {
        light = wallpaperPath;
        dark = wallpaperPath;
      };
      "DP-1" = {
        light = wallpaperPath;
        dark = wallpaperPath;
      };
    };
  };
}
