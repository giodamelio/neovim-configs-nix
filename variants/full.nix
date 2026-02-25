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
      pkgs.ripgrep
      pkgs.fd
      pkgs.git
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
      ../lua/plugins/mini.lua
      ../lua/plugins/luasnip.lua
      ../lua/plugins/trouble.lua
      ../lua/plugins/snacks.lua
      ../lua/plugins/lualine.lua
      ../lua/plugins/rainbow-delimiters.lua
      ../lua/plugins/git.lua
      ../lua/plugins/oil.lua
      ../lua/plugins/other.lua
      ../lua/plugins/smart-splits.lua
      ../lua/plugins/grapple.lua
      ../lua/plugins/persisted.lua
      ../lua/plugins/comment.lua
      ../lua/plugins/stay-centered.lua
      ../lua/plugins/neotest.lua
      ../lua/plugins/elixir.lua
      ../lua/plugins/claude.lua
      ../lua/plugins/treefmt.lua
      ../lua/plugins/misc.lua
      ../lua/neovide.lua
    ];
  }
