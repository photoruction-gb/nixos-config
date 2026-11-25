{ pkgs, ... }: let
  # Follows the system journal of clamonacc (readable thanks to the wheel group)
  # and raises a desktop notification for every detection line.
  clamav-notify = pkgs.writeShellApplication {
    name = "clamav-notify";
    runtimeInputs = [pkgs.systemd pkgs.libnotify];
    text = ''
      journalctl --follow --lines=0 --output=cat --unit=clamav-clamonacc.service \
        | while IFS= read -r line; do
            case "$line" in
              *FOUND*)
                notify-send --urgency=critical --app-name=ClamAV \
                  "Virus detected, access blocked" "$line"
                ;;
            esac
          done
    '';
  };
in {
  systemd.user.services.clamav-notify = {
    Unit = {
      Description = "Desktop notifications for ClamAV on-access detections";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${clamav-notify}/bin/clamav-notify";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
