# Navigation - smart-splits, oil, grapple, other file navigation.
{pkgs, ...}: let
  inherit (import ./lib.nix) nmapLua mapLua;
in {
  config.vim = {
    # Smart splits for pane navigation
    utility.smart-splits.enable = true;

    # Override smart-splits multiplexer auto-detection to only use zellij/tmux.
    # Without this, smart-splits detects WezTerm via $TERM_PROGRAM and tries to
    # initialize its WezTerm integration, which writes to /dev/fd/2. This fails
    # when Neovim is launched from contexts where stderr isn't a normal fd (e.g., OMP).
    luaConfigRC.smart-splits-mux-check = ''
      if vim.env.ZELLIJ then
        vim.g.smart_splits_multiplexer_integration = "zellij"
      elseif vim.env.TMUX then
        vim.g.smart_splits_multiplexer_integration = "tmux"
      else
        vim.g.smart_splits_multiplexer_integration = false
      end
    '';

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
          # Tag management
          {
            mode = "n";
            key = "<leader><leader>a";
            action = "<cmd>lua require('grapple').tag()<cr>";
            desc = "Grapple add tag";
          }
          {
            mode = "n";
            key = "<leader><leader>d";
            action = "<cmd>lua require('grapple').untag()<cr>";
            desc = "Grapple remove tag";
          }
          {
            mode = "n";
            key = "<leader><leader><Tab>";
            action = "<cmd>lua require('grapple').toggle_tags()<cr>";
            desc = "Grapple tags";
          }
          # Quick select by index
          {
            mode = "n";
            key = "<leader><leader>1";
            action = "<cmd>lua require('grapple').select({ index = 1 })<cr>";
            desc = "Grapple 1";
          }
          {
            mode = "n";
            key = "<leader><leader>2";
            action = "<cmd>lua require('grapple').select({ index = 2 })<cr>";
            desc = "Grapple 2";
          }
          {
            mode = "n";
            key = "<leader><leader>3";
            action = "<cmd>lua require('grapple').select({ index = 3 })<cr>";
            desc = "Grapple 3";
          }
          {
            mode = "n";
            key = "<leader><leader>4";
            action = "<cmd>lua require('grapple').select({ index = 4 })<cr>";
            desc = "Grapple 4";
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
    ];
  };
}
