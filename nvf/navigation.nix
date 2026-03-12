# Navigation - smart-splits, oil, grapple, other file navigation.
{pkgs, ...}: let
  inherit (import ./lib.nix) nmapLua mapLua;
in {
  config.vim = {
    # Smart splits for pane navigation
    utility.smart-splits.enable = true;

    # Oil file explorer
    utility.oil-nvim = {
      enable = true;
      setupOpts = {
        columns = ["icon"];
        view_options = {
          show_hidden = true;
        };
      };
    };

    # Lazy plugins
    lazy.plugins = {
      # Quick file tagging
      "grapple.nvim" = {
        package = pkgs.vimPlugins.grapple-nvim;
        cmd = ["Grapple"];
        keys = [
          {
            mode = "n";
            key = "<leader><leader><Tab>m";
            action = "<cmd>lua require('grapple').toggle()<cr>";
            desc = "Grapple toggle tag";
          }
          {
            mode = "n";
            key = "<leader><leader><Tab>M";
            action = "<cmd>lua require('grapple').toggle_tags()<cr>";
            desc = "Grapple open tags";
          }
          {
            mode = "n";
            key = "<leader><leader><Tab>n";
            action = "<cmd>lua require('grapple').cycle_tags('next')<cr>";
            desc = "Grapple next";
          }
          {
            mode = "n";
            key = "<leader><leader><Tab>p";
            action = "<cmd>lua require('grapple').cycle_tags('prev')<cr>";
            desc = "Grapple prev";
          }
        ];
        setupModule = "grapple";
        setupOpts = {};
      };

      # Related file navigation
      "other.nvim" = {
        package = pkgs.vimPlugins.other-nvim;
        cmd = ["Other" "OtherClear" "OtherSplit" "OtherVSplit"];
        keys = [
          {
            mode = "n";
            key = "<leader>oo";
            action = "<cmd>Other<cr>";
            desc = "Open other file";
          }
          {
            mode = "n";
            key = "<leader>oc";
            action = "<cmd>OtherClear<cr>";
            desc = "Clear other file cache";
          }
          {
            mode = "n";
            key = "<leader>os";
            action = "<cmd>OtherSplit<cr>";
            desc = "Open other in split";
          }
          {
            mode = "n";
            key = "<leader>ov";
            action = "<cmd>OtherVSplit<cr>";
            desc = "Open other in vsplit";
          }
        ];
        setupModule = "other-nvim";
        setupOpts = {
          mappings = [
            # Elixir
            {
              pattern = "(.*).ex$";
              target = "%1_test.exs";
              context = "test";
            }
            {
              pattern = "(.*)_test.exs$";
              target = "%1.ex";
              context = "implementation";
            }
            # Rust
            {
              pattern = "src/(.*).rs$";
              target = "tests/%1_test.rs";
              context = "test";
            }
            {
              pattern = "tests/(.*)_test.rs$";
              target = "src/%1.rs";
              context = "implementation";
            }
          ];
        };
      };
    };

    # Navigation keymaps
    keymaps = [
      # Smart splits - resize
      (nmapLua "<A-h>" "require('smart-splits').resize_left()" "Resize left")
      (nmapLua "<A-j>" "require('smart-splits').resize_down()" "Resize down")
      (nmapLua "<A-k>" "require('smart-splits').resize_up()" "Resize up")
      (nmapLua "<A-l>" "require('smart-splits').resize_right()" "Resize right")

      # Smart splits - move between splits
      (mapLua ["n" "t" "v"] "<C-h>" "require('smart-splits').move_cursor_left()" "Move to left split")
      (mapLua ["n" "t" "v"] "<C-j>" "require('smart-splits').move_cursor_down()" "Move to below split")
      (mapLua ["n" "t" "v"] "<C-k>" "require('smart-splits').move_cursor_up()" "Move to above split")
      (mapLua ["n" "t" "v"] "<C-l>" "require('smart-splits').move_cursor_right()" "Move to right split")
      (nmapLua "<C-\\>" "require('smart-splits').move_cursor_previous()" "Move to previous split")

      # Smart splits - swap buffers
      (nmapLua "<leader><leader>h" "require('smart-splits').swap_buf_left()" "Swap buffer left")
      (nmapLua "<leader><leader>j" "require('smart-splits').swap_buf_down()" "Swap buffer down")
      (nmapLua "<leader><leader>k" "require('smart-splits').swap_buf_up()" "Swap buffer up")
      (nmapLua "<leader><leader>l" "require('smart-splits').swap_buf_right()" "Swap buffer right")

      # Grapple
      (nmapLua "<leader><leader><Tab>" "require('grapple').toggle_tags()" "Grapple tags")
      (nmapLua "<leader><leader>a" "require('grapple').tag()" "Grapple add")
      (nmapLua "<leader><leader>d" "require('grapple').untag()" "Grapple remove")
      (nmapLua "<leader><leader>1" "require('grapple').select({ index = 1 })" "Grapple 1")
      (nmapLua "<leader><leader>2" "require('grapple').select({ index = 2 })" "Grapple 2")
      (nmapLua "<leader><leader>3" "require('grapple').select({ index = 3 })" "Grapple 3")
      (nmapLua "<leader><leader>4" "require('grapple').select({ index = 4 })" "Grapple 4")
    ];
  };
}
