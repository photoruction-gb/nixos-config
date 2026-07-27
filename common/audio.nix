{ pkgs, ... }: {
  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
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
    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-mitigate-annoying-profile-switch.conf" ''
          wireplumber.settings = {
            bluetooth.autoswitch-to-headset-profile = false
          }

          monitor.bluez.properties = {
            bluez5.roles = [ a2dp_sink a2dp_source ]
          }
        '')
      ];
    };
  };
}
