{ ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    historySubstringSearch = {
      enable = true;
      searchUpKey = [
        "^[[A"
        "$terminfo[kcuu1]"
      ];
      searchDownKey = [
        "^[[B"
        "$terminfo[kcud1]"
      ];
    };
    history = {
      append = true;
      expireDuplicatesFirst = true;
    };
    shellAliases = {
      ls = "eza --icons --group-directories-first";
      zenith = "zenith -c 0 -d 0 -n 0";
      suspend = "systemctl suspend";
      wormhole = "wormhole-rs";
      slurp-rec = "wl-screenrec -g \"$(slurp)\" -f ~/Videos/video-$(date +%Y-%m-%d_%H-%M-%S).mp4";
      "restart-portal" = "systemctl --user restart xdg-desktop-portal";
    };
    initContent = ''
      eval "$(devenv hook zsh)"
      eval "$(zoxide init zsh --cmd cd)"
    '';
  };
}
