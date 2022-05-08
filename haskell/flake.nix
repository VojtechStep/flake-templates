{
  # XXX: Change project description
  description = "Haskell project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages."${system}";
          # XXX: Change compiler version
          # It's recommended to use a version that is supported
          # by the pre-built HLS binaries - these are listed
          # as `supportedGhcVersions` in
          # https://github.com/NixOS/nixpkgs/blob/nixos-21.11/pkgs/development/tools/haskell/haskell-language-server/withWrapper.nix
          # TODO: switch to ghc922 after NixOS 22.05
          haskell = pkgs.haskell.packages.ghc8107.ghcWithPackages (p: with p;[
            # XXX: Add packages you want
            # To make them available from `cabal repl` and other tooling, you must also
            # add them to the <project>.cabal file
            # Adding them here isn't necessary, Cabal can pull them for you,
            # but it has the advantage of using cached artifacts from nixpkgs
          ]);
        in
        {
          devShells.default = pkgs.mkShell {
            # XXX: Change to project name
            name = "haskell-project";

            # Build tools
            nativeBuildInputs = [
              haskell
              pkgs.haskell-language-server
              pkgs.cabal-install
            ];

            # Runtime dependencies
            buildInputs = [ ];
          };

          devShell = self.devShells."${system}".default;
        });
}
