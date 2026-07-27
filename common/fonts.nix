{ pkgs, ... }: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      nerd-fonts.hack
    ];
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK JP" "DejaVu Serif"];
        sansSerif = ["Noto Sans CJK JP" "DejaVu Sans"];
        monospace = ["Noto Sans Mono CJK JP" "DejaVu Sans Mono"];
      };
    };
  };
}
