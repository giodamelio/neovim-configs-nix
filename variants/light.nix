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

      # Snippets
      luasnip
      friendly-snippets

      # Code Context
      nvim-navic

      # AST — only common grammars
      {
        plugin = nvim-treesitter.withPlugins (p: [
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
        ]);
        name = "nvim-treesitter";
      }
      rainbow-delimiters-nvim

      # Status bar
      lualine-nvim
      lualine-lsp-progress

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

    runtimeDeps = [
      pkgs.ripgrep
      pkgs.fd
    ];

    luaDir = ../lua;
    extraConfig = ''
      let g:neovim_variant = 'light'
    '';
  }
