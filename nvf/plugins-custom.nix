# Custom plugins not covered by NVF built-in modules.
# Uses vim.lazy.plugins for lazy-loadable plugins and vim.startPlugins for eager ones.
{
  pkgs,
  lib,
  vimPlugins,
  unisonPkgs ? null,
  variant ? "full",
  ...
}: let
  isFullVariant = variant == "full";
in {
  config.vim = {
    # Eagerly loaded plugins (dependencies, no setup needed)
    startPlugins = with pkgs.vimPlugins;
      [
        plenary-nvim # Many plugins depend on this
        nvim-web-devicons
        lspkind-nvim # For blink-cmp icons
        vim-eunuch # File operations, no setup needed
      ]
      ++ lib.optionals isFullVariant [
        # Neotest and adapters
        neotest
        nvim-nio
        neotest-rust
        neotest-elixir
        neotest-go
        neotest-deno
        neotest-rspec
        neotest-python
        blink-cmp-git
        firenvim
      ];

    # Lazy-loaded plugins
    lazy.plugins =
      {
        # Session management
        "persisted.nvim" = {
          package = pkgs.vimPlugins.persisted-nvim;
          lazy = false; # Needs to load for auto-restore
          priority = 100;
          setupModule = "persisted";
          setupOpts = {
            autostart = true;
            autoload = true;
          };
        };

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

        # Marks visualization
        "marks.nvim" = {
          package = pkgs.vimPlugins.marks-nvim;
          event = ["BufReadPost" "BufNewFile"];
          setupModule = "marks";
          setupOpts = {};
        };

        # Startup time profiler
        "vim-startuptime" = {
          package = pkgs.vimPlugins.vim-startuptime;
          cmd = ["StartupTime"];
        };

        # Stay centered while scrolling
        "stay-centered.nvim" = {
          package = vimPlugins.stay-centered-nvim;
          event = ["BufReadPost" "BufNewFile"];
          setupModule = "stay-centered";
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

        # Elixir tools
        "elixir-tools.nvim" = {
          package = pkgs.vimPlugins.elixir-tools-nvim;
          ft = ["elixir" "eelixir" "heex" "surface"];
          setupModule = "elixir";
          setupOpts = {
            nextls.enable = false; # Using custom LSP config
            elixirls.enable = false; # Using custom LSP config
          };
        };
      }
      // lib.optionalAttrs isFullVariant {
        # Claude Code integration (full only)
        "claudecode.nvim" = {
          package = pkgs.vimPlugins.claudecode-nvim;
          cmd = ["ClaudeCode" "ClaudeCodeFocus" "ClaudeCodeToggle"];
          keys = [
            {
              mode = "n";
              key = "<leader>cc";
              action = "<cmd>ClaudeCodeToggle<cr>";
              desc = "Toggle Claude";
            }
            {
              mode = "n";
              key = "<leader>cf";
              action = "<cmd>ClaudeCodeFocus<cr>";
              desc = "Focus Claude";
            }
          ];
          setupModule = "claudecode";
          setupOpts = {};
        };

        # jj.nvim for Jujutsu VCS (full only)
        "jj.nvim" = {
          package = vimPlugins.jj-nvim;
          cmd = ["JJ"];
          setupModule = "jj";
          setupOpts = {};
        };
        # Vim-dadbod for database (full only)
        "vim-dadbod" = {
          package = pkgs.vimPlugins.vim-dadbod;
          cmd = ["DB" "DBUI"];
        };

        # Vim-mint for Mint lang (full only)
        "vim-mint" = {
          package = vimPlugins.vim-mint;
          ft = ["mint"];
        };

        # Vim-unison for Unison lang (full only)
        "vimplugin-vim-unison" = lib.mkIf (unisonPkgs != null) {
          package = unisonPkgs.vim-unison;
          ft = ["unison"];
        };

        # Vim-ormolu for Haskell formatting (full only)
        "vim-ormolu" = {
          package = pkgs.vimPlugins.vim-ormolu;
          ft = ["haskell" "lhaskell"];
        };
      };
  };
}
