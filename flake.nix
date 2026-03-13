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

    # Import nixpkgs for a system
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    # Build a single NVF variant
    mkVariant = system: variant:
      nvf.lib.neovimConfiguration {
        pkgs = pkgsFor system;
        modules = [./nvf/core.nix ./nvf/${variant}.nix];
        extraSpecialArgs = {
          inherit system variant;
          unisonPkgs = unison-lang.packages.${system};
          vimPlugins = import ./plugins.nix {pkgs = pkgsFor system;};
        };
      };

    # Build all variants for a system
    mkVariants = system: {
      full = mkVariant system "full";
      light = mkVariant system "light";
      micro = mkVariant system "micro";
    };
  in {
    # Packages - self-contained Neovim binaries
    packages = forAllSystems (system: let
      variants = mkVariants system;
      vimPlugins = import ./plugins.nix {pkgs = pkgsFor system;};
    in {
      default = variants.full.neovim;
      light = variants.light.neovim;
      micro = variants.micro.neovim;

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
      variants = mkVariants system;
    in {
      full = {environment.systemPackages = [variants.full.neovim];};
      light = {environment.systemPackages = [variants.light.neovim];};
      micro = {environment.systemPackages = [variants.micro.neovim];};
    });

    # Home Manager Modules
    homeManagerModules = forAllSystems (system: let
      variants = mkVariants system;
    in {
      full = {home.packages = [variants.full.neovim];};
      light = {home.packages = [variants.light.neovim];};
      micro = {home.packages = [variants.micro.neovim];};
    });

    # Darwin Modules
    darwinModules = forAllSystems (system: let
      variants = mkVariants system;
    in {
      full = {environment.systemPackages = [variants.full.neovim];};
      light = {environment.systemPackages = [variants.light.neovim];};
      micro = {environment.systemPackages = [variants.micro.neovim];};
    });

    formatter = forAllSystems (system: let
      treefmtEval = treefmt-nix.lib.evalModule (pkgsFor system) ./treefmt.nix;
    in
      treefmtEval.config.build.wrapper);

    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
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
          deadnix
          nix-init
          nurl
          prek
          statix
          stylua
          treefmtEval.config.build.wrapper
        ];

        shellHook = ''
          ln --force -s ${optnixConfig} optnix.toml
          prek install
        '';
      };
    });
  };
}
