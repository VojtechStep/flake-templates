{
  # XXX: Change project description
  description = "Zig project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    zig-overlay = {
      url = "github:roarkanize/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, zig-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages."${system}";
          zigs = import zig-overlay { inherit pkgs system; };

          # XXX: Change compiler version
          # supports either version number or build date
          # see https://github.com/roarkanize/zig-overlay/blob/main/sources.json
          zig = zigs."0.9.1";

          zls-config = pkgs.writeText "zls-config.json" (builtins.toJSON {
            zig_exe_path = "${zig}/bin/zig";
            warn_style = true;
          });
          zls-wrapped = pkgs.writeShellScriptBin "zls" ''
            ${pkgs.zls}/bin/zls --config-path ${zls-config}
          '';
        in
        {
          devShells.default = pkgs.mkShell {
            # XXX: Change to project name
            name = "zig-project";

            # Build tools
            nativeBuildInputs = [
              zig
              zls-wrapped
            ];

            # Runtime dependencies
            buildInputs = [ ];
          };

          devShell = self.devShells."${system}".default;
        }
      );
}
