{ ... }: {
  # Using direnv to drive devenv instead of `devenv hook <shell>` /
  # `devenv shell`. The native hook spawns `devenv shell` as a persistent
  # subprocess that runs its own terminal emulator (libghostty_vt) and
  # relays a differentially-rendered copy of the terminal onto the real one,
  # rather than passing raw PTY bytes through. That relay mishandles some
  # escape sequences it doesn't specifically recognize (devenv's own issue
  # tracker has several closed reports of this class of bug, e.g.
  # cachix/devenv#2975, cachix/devenv#2679/#2680): unrecognized sequences
  # fall through to the VT emulator and get rendered as visible garbage. In
  # practice this showed up as a background-color query response
  # (OSC 11, sent by aws-vault and separately by tenv on startup) leaking
  # as literal text onto the prompt whenever those tools ran inside a
  # devenv-managed directory, but not outside one.
  #
  # direnv's `use devenv` instead applies the environment in place, in the
  # current shell process — no subshell, no second pty, no VT emulator in
  # the terminal I/O path at all, so this whole class of bug can't occur.
  # It also has no persistent per-session process (the native `devenv
  # shell` idles at ~40MB RSS / ~26 threads for the whole session; direnv
  # only runs briefly on `cd` to diff and export environment variables).
  #
  # Tradeoffs accepted knowingly: no more in-place hot-reload when
  # devenv.nix changes (needs `direnv reload` or cd out/in instead), and
  # `devenv up`/`devenv tasks`/`devenv test` can use a stale cached
  # environment if you forget to reload after editing devenv.nix. Each
  # devenv project needs a `.envrc` with:
  #   eval "$(devenv direnvrc)"
  #   use devenv
  # and one `direnv allow` run in it.
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
