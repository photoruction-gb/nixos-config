{ pkgs, ... }: let
  # Mirrors kuma-giyomu/nixos-system-flake's home/niri.nix toggle-monitor helper.
  toggle-monitor = pkgs.writeShellApplication {
    name = "niri-toggle-monitor";
    runtimeInputs = [pkgs.jq pkgs.fuzzel pkgs.libnotify];
    text = ''
      outputs_json=$(niri msg -j outputs)

      mapfile -t externals < <(jq -r 'keys[] | select(. != "eDP-1")' <<<"$outputs_json")

      if [ ''${#externals[@]} -eq 0 ]; then
        notify-send "Niri Monitors" "No external monitor detected"
        exit 0
      fi

      if [ ''${#externals[@]} -eq 1 ]; then
        selected="''${externals[0]}"
      else
        menu=$(jq -r --arg edp "eDP-1" '
          to_entries[] | select(.key != $edp) |
          "\(.key): \(.value.make) \(.value.model)"
        ' <<<"$outputs_json")
        chosen=$(printf '%s\n' "$menu" | fuzzel --dmenu --prompt "Monitor: ")
        [ -z "$chosen" ] && exit 0
        selected="''${chosen%%:*}"
      fi

      is_enabled=$(jq -r --arg name "$selected" '.[$name].logical != null' <<<"$outputs_json")
      state="off"
      [ "$is_enabled" = "true" ] && state="on"

      action=$(printf 'Enable\nDisable' | fuzzel --dmenu --prompt "$selected ($state): ")
      [ -z "$action" ] && exit 0

      case "$action" in
        Enable) niri msg output "$selected" on ;;
        Disable) niri msg output "$selected" off ;;
      esac

      notify-send "Niri Monitors" "$selected: $action"
    '';
  };
in {
  home.packages = [toggle-monitor];

  # Watches the clipboard and feeds the "Ctrl+Semicolon" bind below; systemd-managed
  # (WantedBy graphical-session.target), same as kuma-giyomu/nixos-system-flake's
  # home/home.nix. niri's own systemd integration activates that target on startup.
  services.cliphist.enable = true;

  programs.niri.settings = {
    environment = {
      "NIXOS_OZONE_WL" = "1";
      "QS_ICON_THEME" = "Papirus-Dark";
    };

    input = {
      keyboard.xkb = {
        layout = "us";
        options = "ctrl:nocaps";
      };
      touchpad = {
        natural-scroll = false;
      };
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
      };
    };

    xwayland-satellite.enable = true;

    gestures.hot-corners.enable = false;

    cursor = {
      theme = "Bibata-Modern-Classic";
      size = 24;
    };

    outputs = {
      "eDP-1" = {
        scale = 1;
        position = { x = 0; y = 0; };
      };
      "LG Electronics LG ULTRAWIDE 602NTHME0257" = {
        mode = { width = 3440; height = 1440; refresh = 60.0; };
        scale = 1;
        position = { x = 2560; y = 0; };
      };
      "Dell Inc. DELL S3425DW 3YLQQH4" = {
        mode = { width = 3440; height = 1440; refresh = 60.0; };
        scale = 1;
        position = { x = -440; y = -1440; };
      };
      "Dell Inc. DELL SE2426H 4SMPDH4" = {
        mode = { width = 1980; height = 1080; refresh = 60.0; };
        scale = 1;
        position = { x = 290; y = -1080; };
      };
    };

    layout = {
      gaps = 8;
      center-focused-column = "never";
      focus-ring = {
        width = 5;
        active.color = "#ff0000";
      };
      preset-column-widths = [
        { proportion = 0.5; }
        { proportion = 1.0; }
      ];
      preset-window-heights = [
        { proportion = 0.5; }
        { proportion = 1.0; }
      ];
      default-column-width = { proportion = 0.5; };
    };

    screenshot-path = "~/screenshots/%Y-%m-%d_%H-%M-%S.png";

    window-rules = [
      {
        matches = [
          {
            app-id = "firefox$";
            title = "^Picture-in-Picture$";
          }
        ];
        open-floating = true;
      }
    ];

    spawn-at-startup = [
      { argv = ["fcitx5" "-d"]; }
      { argv = ["udiskie" "--tray"]; }
      { argv = ["blueman-applet"]; }
      { argv = ["noctalia-shell"]; }
      { argv = ["lxqt-policykit-agent"]; }
    ];

    hotkey-overlay.skip-at-startup = true;

    # Server-side decorations let niri draw the focus ring/border *around* the
    # window instead of behind it, which stops the ring color from bleeding
    # through windows with a transparent background (e.g. foot).
    prefer-no-csd = true;

    # Bind set matches kuma-giyomu/nixos-system-flake's home/niri.nix.
    binds = {
      # Keys consist of modifiers separated by + signs, followed by an XKB key name
      # in the end. To find an XKB name for a particular key, you may use a program
      # like wev.
      #
      # "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
      # when running as a winit window.
      #
      # Most actions that you can bind here can also be invoked programmatically with
      # `niri msg action do-something`.

      "Mod+Shift+Slash".action.show-hotkey-overlay = [];

      # Suggested binds for running programs: terminal, app launcher, screen locker.
      "Mod+Return" = {
        hotkey-overlay.title = "Open a Terminal: foot";
        action.spawn = ["foot"];
      };
      "Mod+P" = {
        hotkey-overlay.title = "Run an Application: fuzzel";
        action.spawn = ["fuzzel"];
      };
      "Mod+Grave" = {
        action.spawn = ["fcitx5-remote" "-t"];
      };
      "Mod+Alt+L" = {
        hotkey-overlay.title = "Lock the Screen: hyprlock";
        action.spawn = ["hyprlock"];
      };

      # Volume/brightness keys.
      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
      };
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = ["brightnessctl" "--class=backlight" "set" "+10%"];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = ["brightnessctl" "--class=backlight" "set" "10%-"];
      };

      # Open/close the Overview: a zoomed-out view of workspaces and windows.
      "Mod+Shift+O" = {
        repeat = false;
        action.toggle-overview = [];
      };

      "Mod+Shift+Q" = {
        repeat = false;
        action.close-window = [];
      };

      "Mod+Left" = { action.focus-column-left = []; };
      "Mod+Down" = { action.focus-window-down = []; };
      "Mod+Up" = { action.focus-window-up = []; };
      "Mod+Right" = { action.focus-column-right = []; };
      "Mod+H" = { action.focus-column-left = []; };
      "Mod+J" = { action.focus-window-down = []; };
      "Mod+K" = { action.focus-window-up = []; };
      "Mod+L" = { action.focus-column-right = []; };

      "Mod+Ctrl+Left" = { action.focus-monitor-left = []; };
      "Mod+Ctrl+Down" = { action.focus-monitor-down = []; };
      "Mod+Ctrl+Up" = { action.focus-monitor-up = []; };
      "Mod+Ctrl+Right" = { action.focus-monitor-right = []; };
      "Mod+Ctrl+H" = { action.focus-monitor-left = []; };
      "Mod+Ctrl+J" = { action.focus-monitor-down = []; };
      "Mod+Ctrl+K" = { action.focus-monitor-up = []; };
      "Mod+Ctrl+L" = { action.focus-monitor-right = []; };

      "Mod+Home" = { action.focus-column-first = []; };
      "Mod+End" = { action.focus-column-last = []; };
      "Mod+Ctrl+Home" = { action.move-column-to-first = []; };
      "Mod+Ctrl+End" = { action.move-column-to-last = []; };

      "Mod+Shift+Left" = { action.move-column-left = []; };
      "Mod+Shift+Down" = { action.move-window-down = []; };
      "Mod+Shift+Up" = { action.move-window-up = []; };
      "Mod+Shift+Right" = { action.move-column-right = []; };
      "Mod+Shift+H" = { action.move-column-left = []; };
      "Mod+Shift+J" = { action.move-window-down = []; };
      "Mod+Shift+K" = { action.move-window-up = []; };
      "Mod+Shift+L" = { action.move-column-right = []; };

      "Mod+Shift+M" = { action.move-workspace-to-monitor-next = []; };

      "Mod+Page_Down" = { action.focus-workspace-down = []; };
      "Mod+Page_Up" = { action.focus-workspace-up = []; };
      "Mod+U" = { action.focus-workspace-down = []; };
      "Mod+I" = { action.focus-workspace-up = []; };
      "Mod+Ctrl+Page_Down" = { action.move-column-to-workspace-down = []; };
      "Mod+Ctrl+Page_Up" = { action.move-column-to-workspace-up = []; };
      "Mod+Ctrl+U" = { action.move-column-to-workspace-down = []; };
      "Mod+Ctrl+I" = { action.move-column-to-workspace-up = []; };

      "Mod+Shift+Page_Down" = { action.move-workspace-down = []; };
      "Mod+Shift+Page_Up" = { action.move-workspace-up = []; };
      "Mod+Shift+U" = { action.move-workspace-down = []; };
      "Mod+Shift+I" = { action.move-workspace-up = []; };

      "Mod+WheelScrollDown" = {
        cooldown-ms = 150;
        action.focus-workspace-down = [];
      };
      "Mod+WheelScrollUp" = {
        cooldown-ms = 150;
        action.focus-workspace-up = [];
      };
      "Mod+Ctrl+WheelScrollDown" = {
        cooldown-ms = 150;
        action.move-column-to-workspace-down = [];
      };
      "Mod+Ctrl+WheelScrollUp" = {
        cooldown-ms = 150;
        action.move-column-to-workspace-up = [];
      };

      "Mod+WheelScrollRight" = { action.focus-column-right = []; };
      "Mod+WheelScrollLeft" = { action.focus-column-left = []; };
      "Mod+Ctrl+WheelScrollRight" = { action.move-column-right = []; };
      "Mod+Ctrl+WheelScrollLeft" = { action.move-column-left = []; };

      "Mod+Shift+WheelScrollDown" = { action.focus-column-right = []; };
      "Mod+Shift+WheelScrollUp" = { action.focus-column-left = []; };
      "Mod+Ctrl+Shift+WheelScrollDown" = { action.move-column-right = []; };
      "Mod+Ctrl+Shift+WheelScrollUp" = { action.move-column-left = []; };

      "Mod+1" = { action.focus-workspace = 1; };
      "Mod+2" = { action.focus-workspace = 2; };
      "Mod+3" = { action.focus-workspace = 3; };
      "Mod+4" = { action.focus-workspace = 4; };
      "Mod+5" = { action.focus-workspace = 5; };
      "Mod+6" = { action.focus-workspace = 6; };
      "Mod+7" = { action.focus-workspace = 7; };
      "Mod+8" = { action.focus-workspace = 8; };
      "Mod+9" = { action.focus-workspace = 9; };
      "Mod+Ctrl+1" = { action.move-column-to-workspace = 1; };
      "Mod+Ctrl+2" = { action.move-column-to-workspace = 2; };
      "Mod+Ctrl+3" = { action.move-column-to-workspace = 3; };
      "Mod+Ctrl+4" = { action.move-column-to-workspace = 4; };
      "Mod+Ctrl+5" = { action.move-column-to-workspace = 5; };
      "Mod+Ctrl+6" = { action.move-column-to-workspace = 6; };
      "Mod+Ctrl+7" = { action.move-column-to-workspace = 7; };
      "Mod+Ctrl+8" = { action.move-column-to-workspace = 8; };
      "Mod+Ctrl+9" = { action.move-column-to-workspace = 9; };

      "Mod+BracketLeft" = { action.consume-or-expel-window-left = []; };
      "Mod+BracketRight" = { action.consume-or-expel-window-right = []; };
      "Mod+Comma" = { action.consume-window-into-column = []; };
      "Mod+Period" = { action.expel-window-from-column = []; };

      "Mod+R" = { action.switch-preset-column-width = []; };
      "Mod+Shift+R" = { action.switch-preset-window-height = []; };
      "Mod+Ctrl+R" = { action.reset-window-height = []; };
      "Mod+F" = { action.maximize-column = []; };
      "Mod+Shift+F" = { action.fullscreen-window = []; };
      "Mod+Ctrl+F" = { action.expand-column-to-available-width = []; };

      "Mod+C" = { action.center-column = []; };
      "Mod+Ctrl+C" = { action.center-visible-columns = []; };

      "Mod+Minus" = { action.set-column-width = "-10%"; };
      "Mod+Equal" = { action.set-column-width = "+10%"; };
      "Mod+Shift+Minus" = { action.set-window-height = "-10%"; };
      "Mod+Shift+Equal" = { action.set-window-height = "+10%"; };

      "Mod+V" = { action.toggle-window-floating = []; };
      "Mod+Shift+V" = { action.switch-focus-between-floating-and-tiling = []; };
      "Mod+W" = { action.toggle-column-tabbed-display = []; };

      "Ctrl+Semicolon" = {
        hotkey-overlay.title = "Clipboard history: cliphist";
        action.spawn = ["sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"];
      };

      "Mod+Shift+Print" = {
        hotkey-overlay.title = "Record screen region: wl-screenrec";
        action.spawn = ["sh" "-c" ''wl-screenrec -g "$(slurp)" -f ~/Videos/Recordings/$(date '+%Y-%m-%d_%H-%M-%S').mp4''];
      };

      "Print" = { action.screenshot = []; };
      "Ctrl+Print" = { action.screenshot-screen = []; };
      "Alt+Print" = { action.screenshot-window = []; };

      "Mod+Escape" = {
        allow-inhibiting = false;
        action.toggle-keyboard-shortcuts-inhibit = [];
      };

      "Mod+Shift+E" = { action.quit = []; };
      "Ctrl+Alt+Delete" = { action.quit = []; };

      "Mod+Shift+P" = {
        hotkey-overlay.title = "Toggle External Monitor";
        action.spawn = ["niri-toggle-monitor"];
      };
    };
  };
}
