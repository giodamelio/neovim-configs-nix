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
      tokyonight-nvim

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
      {
        plugin = nvim-treesitter.withPlugins (
          _:
            nvim-treesitter.allGrammars
            ++ [
              unison-lang.tree-sitter-grammar
            ]
        );
        name = "nvim-treesitter";
      }
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
      pkgs.ripgrep
      pkgs.fd
      pkgs.git
      pkgs.imagemagick # Snacks: For inline images
      pkgs.netcat-gnu # For Unison LSP
    ];

    luaDir = ../lua;

    extraConfig = ''
      let g:neovim_variant = 'full'
    '';
  }
