{
  description = "Claude Code - Anthropic's agentic coding tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        srcInfo = {
          url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.91.tgz";
          hash = "sha256-u7jdM6hTYN05ZLPz630Yj7gI0PeCSArg4O6ItQRAMy4=";
        };
        src = pkgs.fetchzip srcInfo;
        version = "2.1.91";
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "claude-code";
          inherit version src;

          nativeBuildInputs = [ pkgs.makeWrapper ];

          installPhase = ''
            mkdir -p $out/lib/claude-code $out/bin
            cp -r . $out/lib/claude-code/
            makeWrapper ${pkgs.nodejs}/bin/node $out/bin/claude \
              --add-flags "$out/lib/claude-code/cli.js" \
              --set DISABLE_AUTOUPDATER 1 \
              --set DISABLE_INSTALLATION_CHECKS 1 \
              --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [ procps bubblewrap socat ])}
          '';

          meta = {
            description = "Agentic coding tool that lives in your terminal";
            homepage = "https://github.com/anthropics/claude-code";
            license = pkgs.lib.licenses.unfree;
            mainProgram = "claude";
          };
        };
      }
    );
}
