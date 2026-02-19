# Full Neovim variant — all plugins, all LSP servers, all treesitter grammars.
{
  pkgs,
  vimPlugins,
  unison-lang,
}: let
  mkNeovim = import ../mkNeovim.nix;
in
  mkNeovim {
    inherit pkgs;

    plugins = with pkgs.vimPlugins; [
      # Colorscheme
      {
        plugin = tokyonight-nvim;
        config = "colorscheme tokyonight";
      }

      # Icons
      nvim-web-devicons
      mini-icons
      lspkind-nvim

      # Interactivly show keybinds
      which-key-nvim

      # Pretty lists of things
      trouble-nvim

      # Lots of things need this
      plenary-nvim

      # Language Server
      nvim-lspconfig

      # Autocomplete
      blink-cmp
      blink-cmp-git

      # Snippets
      luasnip
      friendly-snippets

      # Code Context
      nvim-navic

      # AST for hightlighting, formatting, etc
      (nvim-treesitter.withPlugins (
        _:
          nvim-treesitter.allGrammars
          ++ [
            vimPlugins.tree-sitter-surrealdb
            unison-lang.tree-sitter-grammar
          ]
      ))
      rainbow-delimiters-nvim # Rainbow parens
      nvim-treesitter-parsers.hurl

      # Status bar
      lualine-nvim
      lualine-lsp-progress

      # Git stuff
      gitsigns-nvim
      vimPlugins.gitlinker-nvim
      neogit
      diffview-nvim

      # Test running
      neotest
      nvim-nio
      neotest-rust
      neotest-elixir
      neotest-go
      neotest-deno
      neotest-rspec
      neotest-python

      oil-nvim
      comment-nvim
      marks-nvim
      vim-eunuch
      bufdelete-nvim
      vimPlugins.stay-centered-nvim
      vim-startuptime
      elixir-tools-nvim
      other-nvim
      nvim-notify
      claudecode-nvim
      smart-splits-nvim
      snacks-nvim
      persisted-nvim
      mini-ai
      firenvim
      vim-dadbod
      vimPlugins.vim-mint
      unison-lang.vim-unison
      grapple-nvim
      vim-ormolu
    ];

    runtimeDeps = [
      pkgs.imagemagick # Snacks: For inline images
      pkgs.netcat-gnu # For Unison LSP
    ];

    extraConfig = ''
      let g:neovim_variant = 'full'
    '';

    luaModules = [
      ../lua/basic.lua
      ../lua/lsp.lua
      ../lua/lsp-extra.lua
      ../lua/treesitter.lua
      ../lua/plugins/core.lua
      ../lua/plugins/elixir.lua
      ../lua/plugins/neotest.lua
      ../lua/plugins/claude.lua
      ../lua/commands.lua
      ../lua/keybinds/core.lua
      ../lua/keybinds/neotest.lua
      ../lua/keybinds/claude.lua
      ../lua/neovide.lua
    ];
  }
