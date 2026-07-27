{ ... }: {
  home.file.".mozilla/firefox/ghv6g53y.default/user.js".text = ''
    user_pref("privacy.resistFingerprinting", false);
    user_pref("privacy.fingerprintingProtection", true);
    user_pref("privacy.fingerprintingProtection.overrides", "-JSDateTimeUTC");
  '';
}
