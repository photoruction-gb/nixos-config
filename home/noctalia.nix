{ config, pkgs, ... }:
let
  wallpaperPath = "${config.home.homeDirectory}/Pictures/Wallpapers/PhotoructionDesktopPicture.png";

  # niri spawns noctalia-shell once at startup and the running quickshell process
  # has no reliable way to notice that home-manager retargeted
  # ~/.config/noctalia/settings.json to a new store path (see memory:
  # noctalia-shell-restart). This kills the real process (quickshell, not the
  # noctalia-shell launcher) and relaunches it detached from the current shell.
  restart-noctalia = pkgs.writeShellApplication {
    name = "restart-noctalia";
    runtimeInputs = [ pkgs.procps pkgs.coreutils config.programs.noctalia-shell.package ];
    text = ''
      # The Nix-wrapped binary's /proc/*/comm is truncated to ".quickshell-wra",
      # so `pkill -x quickshell` never matches anything. Match on the full
      # command line instead.
      pkill -f 'bin/quickshell' || true

      # Wait for the old process to actually exit before relaunching, otherwise
      # noctalia-shell refuses to start with "instance already running".
      for _ in $(seq 1 25); do
        pgrep -f 'bin/quickshell' >/dev/null || break
        sleep 0.2
      done

      nohup noctalia-shell >/tmp/noctalia-shell.log 2>&1 &
      disown
    '';
  };
in {
  home.packages = [ restart-noctalia ];

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
