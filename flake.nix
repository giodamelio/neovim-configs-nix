{
  description = "My Personal Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Unison Programming Language support
    unison-lang.url = "github:giodamelio/unison-nix/giodamelio/init-ucm-desktop";
    unison-lang.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    unison-lang,
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
      default = import ./package.nix {
        inherit pkgs vimPlugins;
        unison-lang = unisonPkgs;
      };

      # Export vim plugins namespaced like nixpkgs
      "vimPlugins.gitlinker-nvim" = vimPlugins.gitlinker-nvim;
      "vimPlugins.stay-centered-nvim" = vimPlugins.stay-centered-nvim;
      "vimPlugins.vim-mint" = vimPlugins.vim-mint;

      # Also export the treesitter grammar
      "treeSitterPlugins.tree-sitter-surrealdb" = vimPlugins.tree-sitter-surrealdb;
    });
  };
}
