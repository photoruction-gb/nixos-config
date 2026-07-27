{ lib, ... }: {
  # UHK agent copies firmware docs from the read-only Nix store, so the files
  # land with r--r--r-- permissions. Fix them after each switch so the agent
  # can overwrite them on the next run.
  home.activation.fixUhkSmartMacroPerms = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "$HOME/.config/uhk-agent/smart-macro-docs" ]; then
      $DRY_RUN_CMD chmod -R u+w "$HOME/.config/uhk-agent/smart-macro-docs"
    fi
  '';
}
