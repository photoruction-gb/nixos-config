{ config, pkgs, ... }:
let
  wallpaperPath = "${config.home.homeDirectory}/Pictures/Wallpapers/PhotoructionDesktopPicture.png";

  # Same rationale as noctalia-v4.nix's restart-noctalia: niri only spawns the
  # shell once at startup, so a config.toml store-path change needs a manual
  # kill+relaunch to take effect. v5's package wraps a single native "noctalia"
  # binary (wrapProgram renames the real binary to .noctalia-wrapped and
  # generates a wrapper script at bin/noctalia), so /proc/*/comm is truncated
  # the same way quickshell's was — match on the full command line instead.
  restart-noctalia = pkgs.writeShellApplication {
    name = "restart-noctalia";
    runtimeInputs = [ pkgs.procps pkgs.coreutils config.programs.noctalia.package ];
    text = ''
      pkill -f 'bin/.noctalia-wrapped' || true

      for _ in $(seq 1 25); do
        pgrep -f 'bin/.noctalia-wrapped' >/dev/null || break
        sleep 0.2
      done

      nohup noctalia >/tmp/noctalia.log 2>&1 &
      disown
    '';
  };
in {
  home.packages = [ restart-noctalia ];

  # v5 is a from-scratch C++/OpenGL-ES rewrite (Beta upstream, see memory:
  # noctalia_v5_trial). Its home-manager module lives under a different
  # option namespace (programs.noctalia, not programs.noctalia-shell) and
  # writes a single ~/.config/noctalia/config.toml instead of v4's
  # settings.json/colors.json/plugins.json split (see memory:
  # noctalia_shell_settings_persistence).
  #
  # Originally a best-effort transcription of home/noctalia-v4.nix's
  # settings; the bar/dock layout below was since re-synced (2026-08-19) from
  # ~/.local/state/noctalia/settings.toml, the app-writable overrides sidecar
  # the settings UI writes to and that always wins over this file at runtime
  # (see memory: noctalia_shell_settings_persistence) — so this declares
  # what's actually running, not the original v4 mapping.
  # A couple of leftover v4-transcription notes, since the widgets they
  # concerned are no longer configured here:
  #   - Battery's warningThreshold=30: only exposed in v5 via the
  #     `hooks.battery_under_threshold` shell-command hook, not as a
  #     per-widget numeric setting.
  #   - Clock's useMonospacedFont: only a shell-wide `shell.font_family`
  #     exists, not a per-widget font override.
  programs.noctalia = {
    enable = true;
    settings = {
      dock.enabled = false;
      lockscreen.enabled = false;
      bar.main = {
        capsule = false;
        start = [ "sysmon" "workspaces" ];
        center = [ "active_window" ];
        end = [
          "tray"
          "notifications"
          "volume"
          "brightness"
          "battery"
          "network"
          "bluetooth"
          "control-center"
          "clock"
          "session"
        ];
      };
      # v5's "sysmon" widget shows exactly one `stat` per instance (configured
      # globally per widget type via [widget.sysmon], not per-instance), so
      # v4's combined CPU/RAM/disk SystemMonitor view can't be reproduced —
      # cpu_usage was picked as the single stat to keep.
      widget = {
        tray.pinned = [ "Bluetooth*" ];
        clock.format = "{:%H:%M}";
        battery = {
          show_label = true;
          label_content = "percent";
        };
        sysmon.stat = "cpu_usage";
      };
      theme = {
        source = "builtin";
        builtin = "Catppuccin";
      };
      # v4's general.radiusRatio=0.2 and v5's shell.corner_radius_scale use
      # different scales (v5: 0=square, 1=default, 2=extra rounded) but the
      # same low-value-means-squarer direction, so the number was carried
      # over as a best-effort approximation rather than left at v5's default.
      shell.corner_radius_scale = 0.2;
      wallpaper.default.path = wallpaperPath;
    };
  };
}
