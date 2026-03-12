# Base NVF configuration shared by all variants.
# Contains core vim options, leader keys, theme, and foundational settings.
{lib, ...}: {
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
    lsp.enable = lib.mkDefault true;
  };
}
