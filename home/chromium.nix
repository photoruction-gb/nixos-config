{ pkgs, ... }:
let
  # ungoogled-chromium cannot install from the Chrome Web Store, so extensions
  # are sideloaded from a pinned CRX file instead.
  # When the Web Store publishes a new version, the hash below will mismatch:
  # bump `version` and update `sha256` with the value nix reports.
  mkExtension = { id, version, sha256 }: {
    inherit id version;
    crxPath = pkgs.fetchurl {
      name = "${id}-${version}.crx";
      url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${pkgs.ungoogled-chromium.version}&x=id%3D${id}%26installsource%3Dondemand%26uc";
      inherit sha256;
    };
  };
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      # Claude (Claude in Chrome)
      (mkExtension {
        id = "fcoeoabgfenejglbffodgkkbkcdhcgfn";
        version = "1.0.106";
        sha256 = "sha256-QYyXI1XGXMrR/+n5kF9mCQSZLJzQDAallkg+V8hVtck=";
      })
    ];
  };
}
