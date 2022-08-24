{
  # XXX: Change project description
  description = "TypeScript project";

  inputs = {
    # XXX: update to nixos-unstable for typescript-language-server 1.x
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages."${system}";
          # XXX: Change interpreter version
          # After upgrading npm in nodejs 16, the build process
          # is broken, so upstream uses nodePackages with nodejs 14 anyway
          # see https://github.com/NixOS/nixpkgs/issues/132456
          node = pkgs.nodejs-14_x;
          nodePackages = node.pkgs;
        in
        {
          devShells.default = pkgs.mkShell {
            # XXX: Change to project name
            name = "typescript-project";

            # Build tools
            nativeBuildInputs = [ node ] ++ (with nodePackages; [
              typescript
              typescript-language-server
              yarn
            ]);

          };

          devShell = self.devShells."${system}".default;
        });
}
