{ pkgs, ... }: {
  services.envfs.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Deepin Desktop Environment.
  services.xserver.displayManager.lightdm.enable = false;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.tumbler.enable = true;

  services.blueman.enable = true;
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;

  programs.hyprland = {
    enable = true;
  };

  # niri is available alongside hyprland as an alternative compositor;
  # pick whichever session you want at the login/TTY prompt.
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  programs.xfconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      # thunar-volman
    ];
  };

  environment.pathsToLink = [ "/share/zsh" ];

  xdg.mime.defaultApplications = {
    "image/png" = [
      "org.gnome.eog.desktop"
    ];
    "image/webp" = [
      "org.gnome.eog.desktop"
    ];
    "image/jpeg" = [
      "org.gnome.eog.desktop"
    ];
    "image/gif" = [
      "org.gnome.eog.desktop"
    ];
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      hyprland.default = ["hyprland"];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
