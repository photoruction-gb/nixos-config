{ ... }: {
  programs.television.enable = true;
  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };

  programs.starship = {
    enable = true;
    settings = {
      # format = "";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = false;
    options = [
      "--cmd cd"
    ];
  };

  programs.ncmpcpp = {
    enable = true;
  };
}
