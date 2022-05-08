{
  description = "Collection of project templates for Nix flakes";

  outputs = { self }:
    let
      welcome = initCmd: ''
        Don't forget to change the shell name and project description in flake.nix.

        Then run `direnv allow` or `nix develop` to drop into a development shell.
        Run `${initCmd}` to get started.
      '';
    in
    {
      templates = {
        rust = {
          path = ./rust;
          description = "Template for rust projects. Easy changing of compiler versions and target platforms.";
          welcomeText = welcome "cargo init";
        };
        zig = {
          path = ./zig;
          description = "Template for zig projects. Easy changing of compiler versions.";
          welcomeText = welcome "zig init-exe";
        };
        haskell = {
          # TODO: switch to ghc922 after NixOS 22.05
          path = ./haskell;
          description = "Template for haskell projects. Easy changing of compiler versions.";
          welcomeText = welcome "cabal init -m --simple";
        };
        coq = {
          # TODO: Figure out how to structure Coq packages with dune,
          #       make a Dune template
          path = ./coq;
          description = "Template for coq projects. Easy changing of compiler versions.";
          welcomeText = welcome ''echo "-Q . <project_namespace>" >> _CoqProject'';
        };
      };
    };
}
