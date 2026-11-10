{ config, pkgs, lib, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  flakePkg = name: inputs.${name}.packages.${system}.default;
in
{
  imports = [
    ./zsh.nix
    ./direnv.nix
    ./git.nix
    ./cli-tools.nix
    ./mpd.nix
    ./firefox.nix
    ./chromium.nix
    ./uhk.nix
    ./niri.nix
    ./noctalia.nix
    ./hypridle.nix
  ];

  home.packages = with pkgs; [
    appimage-run
    atril
    authenticator
    aws-vault
    awscli2
    beads
    bluetui
    brightnessctl
    bruno
    chafa
    claude-code
    cliphist
    ctpv
    devenv
    dig
    dysk
    eog
    fastfetch
    file
    file-roller
    firefox
    font-awesome
    foot
    fresh-editor
    fuzzel
    gettext
    gh-dash
    gh-enhance
    gimp
    httpie
    httpie-desktop
    hurl
    hyprlock
    inkscape
    jq
    lazydocker
    libreoffice-stable
    lua-language-server
    lxqt.lxqt-policykit
    mpc
    ncdu
    ncpamixer
    nh
    obsidian
    openvpn
    ouch
    p7zip
    papirus-icon-theme
    powertop
    proton-pass
    python3
    remmina
    roboto
    rtk
    rustdesk-flutter
    rustup
    rustlings
    scrcpy
    slack
    slurp
    source-han-sans
    source-sans
    source-sans-pro
    ssm-session-manager-plugin
    starship
    stylua
    systemctl-tui
    taskwarrior3
    timewarrior
    timg
    tree-sitter
    typst
    uhk-agent
    unzip
    vlc
    webp-pixbuf-loader
    wl-clipboard
    wl-screenrec
    xwayland-satellite
    yazi
    zip
    zsh-history-substring-search
  ] ++ [
    (flakePkg "markdown-reader")
  ];

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.11";
}
