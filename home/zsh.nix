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
      eval "$(zoxide init zsh --cmd cd)"

      # Generate the .envrc needed to drive a devenv project via direnv
      # instead of `devenv hook`/`devenv shell` (see home/direnv.nix for
      # why). Refuses to run outside a devenv project and won't clobber an
      # existing .envrc. Runs `direnv allow` once it's written.
      devenv-envrc() {
        local target="''${1:-.}"
        if [[ ! -f "$target/devenv.nix" ]]; then
          echo "devenv-envrc: no devenv.nix in $target, aborting" >&2
          return 1
        fi
        if [[ -f "$target/.envrc" ]]; then
          echo "devenv-envrc: $target/.envrc already exists, not overwriting" >&2
          return 1
        fi
        cat > "$target/.envrc" << 'ENVRC'
      eval "$(devenv direnvrc)"
      use devenv
      ENVRC
        direnv allow "$target"
        echo "devenv-envrc: wrote $target/.envrc and ran direnv allow" >&2
      }
    '';
  };
}
