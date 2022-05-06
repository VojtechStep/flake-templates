{
  # XXX: Change project description
  description = "Rust project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, fenix, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages."${system}";
          # XXX: Change target platform
          rust-target = "x86_64-unknown-linux-musl";
          rust-toolchain = with fenix.packages."${system}"; let
            rust-toolchain-spec = {
              # XXX: Change compiler version
              # see `toolchainOf` https://github.com/nix-community/fenix
              # for supported options
              channel = "1.60";
              sha256 = "sha256-otgm+7nEl94JG/B+TYhWseZsHV1voGcBsW/lOD2/68g=";
            };
            # Toolchain for the builder
            host-toolchain = toolchainOf rust-toolchain-spec;
            # Toolchain for the platform where the binary will run
            target-toolchain = targets."${rust-target}".toolchainOf rust-toolchain-spec;
          in
          combine [
            # Build tools are taken from the host
            host-toolchain.rustc
            host-toolchain.cargo
            host-toolchain.clippy
            host-toolchain.rust-docs
            # Standard library is taken from the target
            target-toolchain.rust-std
          ];
        in
        {
          devShells.default = pkgs.mkShell {
            # XXX: Change to project name
            name = "rust-project";

            # Build tools
            nativeBuildInputs = with pkgs; [
              rust-toolchain
              rust-analyzer
              rustfmt
            ];

            # Runtime dependencies
            buildInputs = [ ];

            RUST_BACKTRACE = 1;
            CARGO_BUILD_TARGET = rust-target;
          };
          devShell = self.devShells."${system}".default;
        });
}
