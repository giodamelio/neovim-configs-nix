# Micro Neovim variant - smallest config with just basic editing + fuzzy finding.
{
  pkgs,
  lib,
  ...
}: {
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
          preset = {
            keys = [
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
        };
        picker.enable = true;
        explorer.enable = true;
      };
    };

    # Basic keybindings for micro
    keymaps = [
      {
        key = "<leader>ff";
        mode = "n";
        action = "<cmd>lua Snacks.picker.files()<cr>";
        desc = "Find files";
      }
      {
        key = "<leader>fg";
        mode = "n";
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        desc = "Find text";
      }
      {
        key = "<leader>fb";
        mode = "n";
        action = "<cmd>lua Snacks.picker.buffers()<cr>";
        desc = "Find buffers";
      }
      {
        key = "<leader>fr";
        mode = "n";
        action = "<cmd>lua Snacks.picker.recent()<cr>";
        desc = "Recent files";
      }
      {
        key = "<leader>`";
        mode = "n";
        action = "<cmd>lua Snacks.explorer.open()<cr>";
        desc = "Explorer";
      }
    ];
    # Runtime dependencies
    extraPackages = with pkgs; [
      ripgrep
      fd
    ];
  };
}
