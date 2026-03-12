# Micro Neovim variant - smallest config with just basic editing + fuzzy finding.
{
  pkgs,
  lib,
  ...
}: let
  inherit (import ./lib.nix) nmapLua;
in {
  config.vim = {
    # Variant identifier
    globals.neovim_variant = "micro";

    # Disable treesitter in micro
    treesitter.enable = lib.mkForce false;

    # Disable LSP in micro
    lsp.enable = lib.mkForce false;

    # Minimal plugins via utility modules
    mini.icons.enable = true;
    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        dashboard = {
          enable = true;
          # Minimal sections - no startup stats (requires lazy.nvim)
          sections = [
            {section = "header";}
            {
              section = "keys";
              gap = 1;
              padding = 1;
            }
            {
              section = "recent_files";
              padding = 1;
            }
          ];
          preset.keys = [
            {
              icon = " ";
              key = "f";
              desc = "Find File";
              action = ":lua Snacks.picker.files()";
            }
            {
              icon = " ";
              key = "g";
              desc = "Find Text";
              action = ":lua Snacks.picker.grep()";
            }
            {
              icon = " ";
              key = "r";
              desc = "Recent Files";
              action = ":lua Snacks.picker.recent()";
            }
            {
              icon = " ";
              key = "q";
              desc = "Quit";
              action = ":qa";
            }
          ];
        };
        picker.enable = true;
        explorer.enable = true;
      };
    };

    # Which-key groups
    binds.whichKey.register = {
      "<leader>f" = "Find";
    };

    # Keymaps using helpers
    keymaps = [
      (nmapLua "<leader>ff" "Snacks.picker.files()" "Find files")
      (nmapLua "<leader>fg" "Snacks.picker.grep()" "Find text")
      (nmapLua "<leader>fb" "Snacks.picker.buffers()" "Find buffers")
      (nmapLua "<leader>fr" "Snacks.picker.recent()" "Recent files")
      (nmapLua "<leader>`" "Snacks.explorer.open()" "Explorer")
    ];

    # Runtime dependencies
    extraPackages = with pkgs; [
      ripgrep
      fd
    ];
  };
}
