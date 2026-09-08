{ lib, buildGoModule, go_1_27, src }:

# masume (github.com/turanmahmudov/masume) is a terminal database client for
# PostgreSQL, MySQL, SQLite, MongoDB, and protocol-compatible servers.
#
# go.mod declares `go 1.27`; nixpkgs' default `go` in this channel is older,
# so the Go 1.27 toolchain is pinned explicitly rather than left to the
# default `buildGoModule` package.
buildGoModule.override { go = go_1_27; } rec {
  pname = "masume";
  version = src.shortRev or "unstable-${src.lastModifiedDate or "unknown"}";

  inherit src;

  # Recompute with `nix build --rebuild` (or by setting this to
  # lib.fakeHash and reading the mismatch) whenever go.mod/go.sum change.
  vendorHash = "sha256-MJo0X9X0SH75CeKKFb799C2m8SC/Qs1pyTK3ircX4KQ=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/turanmahmudov/masume/internal/cli.Version=${version}"
  ];

  # The upstream test suite needs Docker-composed database servers and a
  # reachable OS keyring; neither is available in the build sandbox.
  doCheck = false;

  meta = {
    description = "Terminal database client for PostgreSQL, MySQL, SQLite, MongoDB, and compatible servers";
    homepage = "https://github.com/turanmahmudov/masume";
    license = lib.licenses.asl20;
    mainProgram = "masume";
    platforms = lib.platforms.unix;
  };
}
