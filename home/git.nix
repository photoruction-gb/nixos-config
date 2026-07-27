{ ... }: {
  programs.gh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      safe.directory = "/home/guillaume/nixos";
    };
  };
}
