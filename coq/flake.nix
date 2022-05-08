{
  # XXX: Change project description
  description = "Coq project";

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
          coqPackages = pkgs.coqPackages_8_14;
        in
        {
          devShells.default = pkgs.mkShell {
            # XXX: Change to project name
            name = "coq-project";

            # Build tools
            nativeBuildInputs = [
              # alternatively `coq.override { buildIde = false; }
              # which reduces the package size, but is not in binary caches
              coqPackages.coq
            ];

          };
          devShell = self.devShells."${system}".default;
        });
}
