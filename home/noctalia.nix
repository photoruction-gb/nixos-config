{ config, ... }:
let
  wallpaperPath = "${config.home.homeDirectory}/Pictures/Wallpapers/PhotoructionDesktopPicture.png";
in {
  # noctalia is a native C++/OpenGL-ES Wayland shell (Beta upstream, see
  # memory: noctalia_v5_trial). Its home-manager module writes a single
  # ~/.config/noctalia/config.toml; settings changed via the settings UI are
  # written to an app-writable overrides sidecar at
  # ~/.local/state/noctalia/settings.toml, which always wins over this file
  # at runtime (see memory: noctalia_shell_settings_persistence). The
  # bar/dock/lockscreen toggles below were synced from that sidecar
  # (2026-08-19) to keep this file matching what's actually running.
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
      # noctalia's "sysmon" widget shows exactly one `stat` per instance
      # (configured globally per widget type via [widget.sysmon], not
      # per-instance) — cpu_usage was picked as the single stat to show.
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
      shell.corner_radius_scale = 0.2;
      wallpaper.default.path = wallpaperPath;
    };
  };
}
