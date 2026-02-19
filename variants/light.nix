# Light Neovim variant — core plugins only, minimal closure size.
{
  pkgs,
  vimPlugins,
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

      # AST — only common grammars
      (nvim-treesitter.withPlugins (p: [
        p.lua
        p.nix
        p.python
        p.rust
        p.go
        p.javascript
        p.typescript
        p.json
        p.yaml
        p.toml
        p.bash
        p.html
        p.css
        p.markdown
        p.markdown_inline
        p.vim
        p.vimdoc
        p.elixir
        p.heex
        p.eex
        p.erlang
      ]))
      rainbow-delimiters-nvim

      # Status bar
      lualine-nvim
      lualine-lsp-progress

      # Git stuff
      gitsigns-nvim
      vimPlugins.gitlinker-nvim
      neogit
      diffview-nvim

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
      smart-splits-nvim
      snacks-nvim
      persisted-nvim
      mini-ai
      grapple-nvim
    ];

    extraConfig = ''
      let g:neovim_variant = 'light'
    '';

    luaModules = [
      ../lua/basic.lua
      ../lua/lsp.lua
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
      ../lua/plugins/elixir.lua
      ../lua/plugins/treefmt.lua
      ../lua/plugins/misc.lua
      ../lua/neovide.lua
    ];
  }
