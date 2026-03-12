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

    # Helper to create NVF variants
    mkVariant = {
      system,
      modules,
      extraSpecialArgs ? {},
    }:
      nvf.lib.neovimConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        inherit modules;
        extraSpecialArgs =
          {
            inherit system;
            unisonPkgs = unison-lang.packages.${system};
            vimPlugins = import ./plugins.nix {
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
            };
          }
          // extraSpecialArgs;
      };
  in {
    # Packages - self-contained Neovim binaries
    packages = forAllSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Custom vim plugins
      vimPlugins = import ./plugins.nix {inherit pkgs;};

      full = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/full.nix];
        extraSpecialArgs.variant = "full";
      };

      light = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/light.nix];
        extraSpecialArgs.variant = "light";
      };

      micro = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/micro.nix];
        extraSpecialArgs.variant = "micro";
      };
    in {
      # Full variant (default)
      default = full.neovim;

      # Light variant - smaller closure for servers / minimal use
      light = light.neovim;

      # Micro variant - smallest config with fuzzy finding only
      micro = micro.neovim;

      # Export vim plugins namespaced like nixpkgs
      "vimPlugins.gitlinker-nvim" = vimPlugins.gitlinker-nvim;
      "vimPlugins.stay-centered-nvim" = vimPlugins.stay-centered-nvim;
      "vimPlugins.vim-mint" = vimPlugins.vim-mint;
      "vimPlugins.jj-nvim" = vimPlugins.jj-nvim;
    });

    # NVF Modules for reuse
    nvfModules = {
      core = ./nvf/core.nix;
      snacks = ./nvf/snacks.nix;
      lsp = ./nvf/lsp.nix;
      git = ./nvf/git.nix;
      navigation = ./nvf/navigation.nix;
      treefmt = ./nvf/treefmt.nix;
      nix = ./nvf/nix.nix;
      neotest = ./nvf/neotest.nix;
      claude = ./nvf/claude.nix;
      extra-langs = ./nvf/extra-langs.nix;
      full = ./nvf/full.nix;
      light = ./nvf/light.nix;
      micro = ./nvf/micro.nix;
      neovide = ./nvf/neovide.nix;
      lib = ./nvf/lib.nix;
    };

    # NixOS Modules
    nixosModules = forAllSystems (system: let
      full = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/full.nix];
        extraSpecialArgs.variant = "full";
      };
      light = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/light.nix];
        extraSpecialArgs.variant = "light";
      };
      micro = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/micro.nix];
        extraSpecialArgs.variant = "micro";
      };
    in {
      full = {environment.systemPackages = [full.neovim];};
      light = {environment.systemPackages = [light.neovim];};
      micro = {environment.systemPackages = [micro.neovim];};
    });

    # Home Manager Modules
    homeManagerModules = forAllSystems (system: let
      full = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/full.nix];
        extraSpecialArgs.variant = "full";
      };
      light = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/light.nix];
        extraSpecialArgs.variant = "light";
      };
      micro = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/micro.nix];
        extraSpecialArgs.variant = "micro";
      };
    in {
      full = {home.packages = [full.neovim];};
      light = {home.packages = [light.neovim];};
      micro = {home.packages = [micro.neovim];};
    });

    # Darwin Modules
    darwinModules = forAllSystems (system: let
      full = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/full.nix];
        extraSpecialArgs.variant = "full";
      };
      light = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/light.nix];
        extraSpecialArgs.variant = "light";
      };
      micro = mkVariant {
        inherit system;
        modules = [./nvf/core.nix ./nvf/micro.nix];
        extraSpecialArgs.variant = "micro";
      };
    in {
      full = {environment.systemPackages = [full.neovim];};
      light = {environment.systemPackages = [light.neovim];};
      micro = {environment.systemPackages = [micro.neovim];};
    });

    formatter = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
      treefmtEval.config.build.wrapper);

    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

      # Generate a set of options and a Optnix config for NVF
      optnixLib = optnix.mkLib pkgs;
      nvfModuleInstance = nvf.lib.neovimConfiguration {inherit pkgs;};
      nvfOptionsList = optnixLib.mkOptionsList {
        inherit (nvfModuleInstance) options;
      };
      optnixConfig = (pkgs.formats.toml {}).generate "optnix.toml" {
        default_scope = "nvf";
        scopes.nvf = {
          description = "Neovim configuation module system";
          options-list-file = nvfOptionsList;
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
