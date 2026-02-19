{
  description = "My Personal Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Unison Programming Language support
    unison-lang.url = "github:giodamelio/unison-nix/giodamelio/init-ucm-desktop";
    unison-lang.inputs.nixpkgs.follows = "nixpkgs";

    # Formatting
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    unison-lang,
    treefmt-nix,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    packages = forAllSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      unisonPkgs = unison-lang.packages.${system};

      # Custom vim plugins
      vimPlugins = import ./plugins.nix {inherit pkgs;};
    in {
      # Full variant (default)
      default = import ./variants/full.nix {
        inherit pkgs vimPlugins;
        unison-lang = unisonPkgs;
      };

      # Light variant — smaller closure for servers / minimal use
      light = import ./variants/light.nix {
        inherit pkgs vimPlugins;
      };

      # Micro variant — smallest config with fuzzy finding only
      micro = import ./variants/micro.nix {
        inherit pkgs;
      };

      # Export vim plugins namespaced like nixpkgs
      "vimPlugins.gitlinker-nvim" = vimPlugins.gitlinker-nvim;
      "vimPlugins.stay-centered-nvim" = vimPlugins.stay-centered-nvim;
      "vimPlugins.vim-mint" = vimPlugins.vim-mint;

      # Also export the treesitter grammar
      "treeSitterPlugins.tree-sitter-surrealdb" = vimPlugins.tree-sitter-surrealdb;
    });

    formatter = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
      treefmtEval.config.build.wrapper);

    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in {
      default = pkgs.mkShell {
        packages = [treefmtEval.config.build.wrapper];
      };
    });
  };
}
