# Core NVF configuration - vim options, theme, universal plugins.
{
  pkgs,
  lib,
  vimPlugins,
  ...
}: let
  inherit (import ./lib.nix) cmd nmap;
in {
  config.vim = {
    # Leader keys
    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };

    # Core vim options (from basic.lua)
    options = {
      # Tab settings - 2 spaces
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;

      # Line numbers
      number = true;
      relativenumber = true;

      # Smart search
      ignorecase = true;
      smartcase = true;

      # System clipboard
      clipboard = "unnamedplus";

      # Show trailing whitespace
      list = true;
      listchars = "trail:·,tab:  ";

      # Cursor line highlight
      cursorline = true;

      # Disable mouse
      mouse = "";

      # Completion options
      completeopt = "menu,menuone,noselect";

      # 24-bit color
      termguicolors = true;

      # File change detection
      autoread = true;
      updatetime = 100;
    };

    # Theme - tokyonight
    theme = {
      enable = true;
      name = "tokyonight";
      style = "moon"; # tokyonight default
    };

    # Core enables
    treesitter.enable = lib.mkDefault true;
    treesitter.fold = true;
    lsp.enable = lib.mkDefault true;

    # Which-key
    binds.whichKey = {
      enable = true;
      register = {
        "<leader>f" = "Find";
        "<leader>l" = "LSP";
        "<leader>d" = "Diagnostics";
        "<leader>t" = "Testing";
        "<leader>o" = "Other";
        "<leader><leader>" = "Swap/Grapple";
      };
    };

    # Mini plugins
    mini.icons.enable = true;
    mini.ai.enable = true;
    mini.bufremove.enable = true;

    # UI plugins
    comments.comment-nvim.enable = true;
    visuals.rainbow-delimiters = {
      enable = true;
      setupOpts.blacklist = ["snacks_dashboard"];
    };
    visuals.fidget-nvim.enable = true;
    statusline.lualine = {
      enable = true;
      # NVF lualine has inline LSP progress, no need for lualine-lsp-progress plugin
    };
    ui.breadcrumbs = {
      enable = true;
      lualine.winbar.enable = true;
    };

    # Eager plugins
    startPlugins = with pkgs.vimPlugins; [
      plenary-nvim # Many plugins depend on this
      nvim-web-devicons
      vim-eunuch # File operations, no setup needed
    ];

    # Lazy plugins
    lazy.plugins = {
      # Session management
      "persisted.nvim" = {
        package = pkgs.vimPlugins.persisted-nvim;
        lazy = false; # Needs to load for auto-restore
        priority = 100;
        setupModule = "persisted";
        setupOpts = {
          autostart = true;
          autoload = false;
        };
      };

      # Marks visualization
      "marks.nvim" = {
        package = pkgs.vimPlugins.marks-nvim;
        event = ["BufReadPost" "BufNewFile"];
        setupModule = "marks";
        setupOpts = {};
      };

      # Stay centered while scrolling
      "stay-centered.nvim" = {
        package = vimPlugins.stay-centered-nvim;
        event = ["BufReadPost" "BufNewFile"];
        setupModule = "stay-centered";
        setupOpts = {};
      };

      # Startup time profiler
      "vim-startuptime" = {
        package = pkgs.vimPlugins.vim-startuptime;
        cmd = ["StartupTime"];
      };
    };

    # Keymaps
    keymaps = [
      (nmap "<leader><Tab>" (cmd "b#") "Switch to last buffer")
    ];

    # Lua config
    luaConfigRC = {
      debug-helpers = builtins.readFile ./lua/debug-helpers.lua;
      user-commands = builtins.readFile ./lua/user-commands.lua;
      persisted-picker = builtins.readFile ./lua/persisted-picker.lua;
    };
  };
}
