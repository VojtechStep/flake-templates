{
  # XXX: Change project description
  description = "Agda project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages."${system}";
          agda = pkgs.agda.withPackages (p: with p;[
            # XXX: Add packages you want
            # Then, list them in the `depends: `
            # section of <project>.agda-lib
          ]);
        in
        {
          devShells.default = pkgs.mkShell {
            # XXX: Change to project name
            name = "agda-project";

            # Build tools
            nativeBuildInputs = [
              agda
            ];

            # Runtime dependencies
            buildInputs = [ ];
          };

          devShell = self.devShells."${system}".default;
        });
}
