{ ... }: {
  services.mpd = {
    enable = true;
    musicDirectory = "/home/guillaume/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
  };
}
