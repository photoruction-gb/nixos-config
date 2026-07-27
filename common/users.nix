{ config, pkgs, lib, ... }: {
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = { # hardware.graphics since NixOS 24.11
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    alejandra
    android-tools
    bat
    bibata-cursors
    bottom
    curl
    delta
    dive
    docker-compose
    eza
    fd
    fzf
    gcc
    gnumake
    killall
    lazygit
    libnotify
    magic-wormhole-rs
    nwg-look
    openssl
    pavucontrol
    ripgrep
    sshfs
    tig
    udiskie
    udisks2
    unzip
    usbutils
    vimPlugins.telescope-fzf-native-nvim
    # vimPlugins.avante-nvim
    wget
    zenith
    zsh
    zsh-fzf-history-search
    zsh-fzf-tab
  ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.guillaume = {
    isNormalUser = true;
    description = "guillaume";
    extraGroups = ["networkmanager" "wheel" "docker" "adbusers" "podman"];
    shell = pkgs.zsh;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.git = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    promptInit = ''
      export PATH="$HOME/.cargo/bin:$PATH"
    '';
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    INPUT_METHOD = "fcitx";
    QT_IM_MODULE = "fcitx";
    # GTK_IM_MODULE = "fcitx";
    "XMODIFIERS=@im" = "fcitx";
    XIM_SERVERS = "fcitx";
    DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
    DOCKER_SOCK = "/run/user/1000/podman/podman.sock";
    # vaapi
    LIBVA_DRIVER_NAME = "iHD";
  };

  programs.direnv = {
    enable = true;
  };
}
