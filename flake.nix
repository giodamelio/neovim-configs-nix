{
  description = "My Personal Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    # Unison Programming Language support
    unison-lang.url = "github:giodamelio/unison-nix/giodamelio/init-ucm-desktop";
    unison-lang.inputs.nixpkgs.follows = "nixpkgs";

    # Formatting
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Module Options search based directly on modules themselves
    optnix.url = "sourcehut:~watersucks/optnix";
    optnix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    unison-lang,
    treefmt-nix,
    nvf,
    optnix,
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
      "vimPlugins.jj-nvim" = vimPlugins.jj-nvim;
    });

    formatter = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
      treefmtEval.config.build.wrapper);

    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      inherit (pkgs) lib;
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

      # Generate a set of options and a Optnix config for NVF
      optnixLib = optnix.mkLib pkgs;
      nvfModuleInstance = nvf.lib.neovimConfiguration { inherit pkgs; };
      nvfOptionsList = optnixLib.mkOptionsList {
        inherit (nvfModuleInstance) options;
      };
      optnixConfig = (pkgs.formats.toml {}).generate "optnix.toml" {
        default_scope = "nvf";
        scopes.nvf = {
          description = "Neovim configuation module system";
          options-list-file = nvfOptionsList;

          # Start of an evaluater command, but we would need to seperate out seperate scopes per variant
          # I think we would have a problem with the programs.nvf.settings prefix as well here
          # evaluator = "nix eval --impure --expr "let flake = builtins.getFlake \"$PWD\"; pkgs = import flake.inputs.nixpkgs { system = builtins.currentSystem; }; nvf = flake.inputs.nvf.lib.neovimConfiguration { inherit pkgs; }; in config.{{ .Option }}"
        };
      };
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          nix-init
          nurl
          treefmtEval.config.build.wrapper
        ];

        shellHook = ''
          ln --force -s ${optnixConfig} optnix.toml
        '';
      };
    });
  };
}
