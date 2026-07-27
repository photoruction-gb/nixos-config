{ pkgs, ... }: {
  services.udev.packages = [
    # pkgs.android-udev-rules
  ];

  services.udev.extraRules = ''
    # uhk (legacy vendor ID)
    SUBSYSTEM=="input", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", GROUP="input", MODE="0660"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", MODE:="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", MODE="0666", TAG+="uaccess"
    # uhk (UHK 60 v2, vendor 37a8)
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="37a8", MODE:="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="37a8", MODE="0666", TAG+="uaccess"
  '';
}
