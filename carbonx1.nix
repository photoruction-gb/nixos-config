# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  unstable = import <nixos-unstable> {
    config = {allowUnfree = true;};
  };
in {
  imports = [<home-manager/nixos>];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-6ab574dc-dbf0-4a1d-b8a3-98a9e02fa1df".device = "/dev/disk/by-uuid/6ab574dc-dbf0-4a1d-b8a3-98a9e02fa1df";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.extraHosts =
  ''
    127.0.0.1 minio-localhost
  '';

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Deepin Desktop Environment.
  services.xserver.displayManager.lightdm.enable = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alejandra
    amdvlk
    bat
    bottom
    curl
    delta
    docker
    eza
    fd
    fzf
    fzf-zsh
    gcc
    gnumake
    killall
    lazydocker
    lazygit
    libnotify
    magic-wormhole-rs
    pavucontrol
    ripgrep
    sshfs
    tig
    udiskie
    udisks2
    vimPlugins.telescope-fzf-native-nvim
    wget
    zenith
    zsh
    zsh-fzf-history-search
    zsh-fzf-tab
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.guillaume = {
    isNormalUser = true;
    description = "guillaume";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
  };

  home-manager.users.guillaume = {pkgs, ...}: {
    home.packages = with pkgs; [
      authenticator
      aws-vault
      awscli2
      unstable.beekeeper-studio
      chafa
      clipman
      ctpv
      ferdium
      firefox-wayland
      foot
      fuzzel
      gimp
      gnome.adwaita-icon-theme
      gnome.eog
      grim
      httpie
      hyprland
      hyprpaper
      inkscape
      lf
      libreoffice-fresh
      jq
      mako
      mate.atril
      papirus-icon-theme
      pcmanfm
      rustup
      slurp
      ssm-session-manager-plugin
      taskwarrior
      timewarrior
      ungoogled-chromium
      vlc
      waybar
      webp-pixbuf-loader
      wl-clipboard
      zsh-powerlevel10k
    ];
    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
      };
      shellAliases = {
        ls = "eza --icons --group-directories-first";
        zenith = "zenith -c 0 -d 0 -n 0";
        suspend = "systemctl suspend";
        wormhole = "wormhole-rs";
      };
    };
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
    };
    programs.lf = {
      previewer = {
        keybinding = "i";
        source = "${pkgs.ctpv}/bin/ctpv";
      };
      extraConfig = ''
        &${pkgs.ctpv}/bin/ctpv -s $id
        cmd on-quit %${pkgs.ctpv}/bin/ctpv -e $id
        set cleaner ${pkgs.ctpv}/bin/ctpvclear
      '';
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      (nerdfonts.override {fonts = ["Hack"];})
    ];
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK JP" "DejaVu Serif"];
        sansSerif = ["Noto Sans CJK JP" "DejaVu Sans"];
        monospace = ["Noto Sans Mono CJK JP" "DejaVu Sans Mono"];
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.blueman.enable = true;
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
    ];
  };

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
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      test -f ~/.p10k.zsh && source ~/.p10k.zsh
    '';
  };

  environment = {
    sessionVariables = {
      INPUT_METHOD = "fcitx";
      QT_IM_MODULE = "fcitx";
      # GTK_IM_MODULE = "fcitx";
      "XMODIFIERS=@im" = "fcitx";
      XIM_SERVERS = "fcitx";
    };
  };

  programs.direnv.enable = true;

  programs.hyprland = {
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };

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
}
