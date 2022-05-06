{
  description = "Collection of project templates for Nix flakes";

  outputs = { self }:
    {
      templates = {
        rust = {
          path = ./rust;
          description = "Template for rust projects. Easy changing of compiler versions and target platforms.";
          welcomeText = ''
            Don't forget to change the shell name and project description in flake.nix.

            Then run `direnv allow` or `nix develop` to get started.
            Run `cargo init` to initialize the Rust codebase.
          '';
        };
      };
    };
}
