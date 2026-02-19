{
  pkgs,
  vimPlugins,
  unison-lang,
}: let
  nvimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = true;
    withRuby = false;
    vimAlias = true;
    viAlias = true;

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
      gitsigns-nvim # Git status in the gutter
      vimPlugins.gitlinker-nvim # Easily link to specific file locations
      neogit # Git ui
      diffview-nvim # Better diffs

      # Test running
      neotest
      nvim-nio # Needed dependency
      neotest-rust
      neotest-elixir
      neotest-go
      neotest-deno
      neotest-rspec
      neotest-python

      avante-nvim # GenAI addition
      oil-nvim # Move/Create/Delete files/directories directly in a vim buffer
      comment-nvim # Better comments
      marks-nvim # Show marks in the sign column
      vim-eunuch # Do a Unix to it
      bufdelete-nvim # Better behaved :Bedelete (keeps splits etc...)
      vimPlugins.stay-centered-nvim # Keep the cursor line centered vertically as much as possible
      vim-startuptime # Keep on top of Neovim startup time
      elixir-tools-nvim # Elixir tooling
      other-nvim # Easily switch to related file types
      nvim-notify # Pretty notifications
      claudecode-nvim # Integration with Claude Code
      smart-splits-nvim # Easy Multiplexer Split Navigation
      snacks-nvim # Collection of small quality of life plugins by Folke
      persisted-nvim # Session manager
      mini-ai # Better a/i text objects
      firenvim # Use Neovim in the browser
      vim-dadbod # Interact with databases
      vimPlugins.vim-mint # Syntax for the Mint language
      unison-lang.vim-unison # Unison lang support
      grapple-nvim # Easy switching between important files
      vim-ormolu # Haskell autoformatting
    ];

    customRC = "
      luafile ${./lua/basic.lua}
      luafile ${./lua/lsp.lua}
      luafile ${./lua/treesitter.lua}
      luafile ${./lua/plugins.lua}
      luafile ${./lua/commands.lua}
      luafile ${./lua/keybinds.lua}
      luafile ${./lua/neovide.lua}
    ";
  };
in
  pkgs.symlinkJoin {
    name = "nvim";
    meta.mainProgram = "nvim";
    paths = [
      # Custom Neovim
      (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped nvimConfig)

      # Some random dependencies
      pkgs.imagemagick # Snacks: For inline images

      # For Unison LSP
      pkgs.netcat-gnu
    ];
  }
