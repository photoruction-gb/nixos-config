{ ... }: {
  # Mirrors kuma-giyomu/nixos-system-flake's home/home.nix hypridle block: niri-native
  # power-on/off-monitors IPC instead of Hyprland's `hyprctl dispatch dpms`, since niri
  # is the primary compositor here (hyprland kept only as a manual fallback).
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1200;
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
        {
          timeout = 3600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
