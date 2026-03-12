# Built-in NVF plugin modules configuration.
# These are plugins that have dedicated NVF module support.
{
  lib,
  variant ? "full",
  ...
}:
let
  # mkLuaInline not needed - snacks setupOpts are passed directly
  isFullVariant = variant == "full";
in
{
  config.vim = {
    # Icons
    mini.icons.enable = true;

    # Which-key for interactive keybind help
    binds.whichKey.enable = true;

    # Trouble for pretty diagnostic lists
    lsp.trouble.enable = true;

    # Snippets
    snippets.luasnip.enable = true;

    # Mini.ai for better text objects
    mini.ai.enable = true;

    # Mini.bufremove replaces bufdelete.nvim
    mini.bufremove.enable = true;

    # Rainbow delimiters for nested parens
    visuals.rainbow-delimiters.enable = true;

    # Comment.nvim for code commenting
    comments.comment-nvim.enable = true;

    # Smart splits for pane navigation
    utility.smart-splits.enable = true;

    # Diffview for git diffs
    utility.diffview-nvim.enable = true;

    # Nvim-notify for notifications
    notify.nvim-notify.enable = true;

    # Breadcrumbs (nvim-navic)
    ui.breadcrumbs = {
      enable = true;
      lualine.winbar.enable = true;
    };

    # Git integration
    git = {
      gitsigns.enable = lib.mkDefault true;
      neogit.enable = lib.mkDefault true;
      gitlinker-nvim = {
        enable = lib.mkDefault true;
        setupOpts = {
          mapping = null; # Disable default mapping, we define our own
        };
      };
    };

    # Status line
    statusline.lualine = {
      enable = true;
      # NVF lualine has inline LSP progress, no need for lualine-lsp-progress plugin
    };

    # Oil file explorer
    utility.oil-nvim = {
      enable = true;
      setupOpts = {
        columns = [ "icon" ];
        view_options = {
          show_hidden = true;
        };
      };
    };

    # Snacks - dashboard, picker, terminal, indent, notify, explorer
    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        dashboard = {
          enable = true;
          preset = {
            keys = [
              {
                icon = " ";
                key = "f";
                desc = "Find File";
                action = ":lua Snacks.dashboard.pick('files')";
              }
              {
                icon = " ";
                key = "g";
                desc = "Find Text";
                action = ":lua Snacks.dashboard.pick('live_grep')";
              }
              {
                icon = " ";
                key = "r";
                desc = "Recent Files";
                action = ":lua Snacks.dashboard.pick('oldfiles')";
              }
              {
                icon = " ";
                key = "c";
                desc = "Config";
                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.expand('$HOME/nixos-configs/nix/packages/neovim')})";
              }
              {
                icon = " ";
                key = "n";
                desc = "Nix Configs";
                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.expand('$HOME/nixos-configs')})";
              }
              {
                icon = " ";
                key = "s";
                desc = "Restore Session";
                section = "session";
              }
              {
                icon = " ";
                key = "q";
                desc = "Quit";
                action = ":qa";
              }
            ];
          };
          sections = [
            { section = "header"; }
            {
              section = "keys";
              gap = 1;
              padding = 1;
            }
            {
              pane = 2;
              icon = " ";
              title = "Recent Files";
              section = "recent_files";
              indent = 2;
              padding = 1;
            }
            {
              pane = 2;
              icon = " ";
              title = "Projects";
              section = "projects";
              indent = 2;
              padding = 1;
            }
            {
              pane = 2;
              icon = " ";
              title = "Git Status";
              section = "terminal";
              # enabled callback - snacks handles this as Lua
              enabled = "function() return Snacks.git.get_root() ~= nil end";
              cmd = "git status --short --branch --renames";
              height = 5;
              padding = 1;
              ttl = 300;
              indent = 3;
            }
          ];
          pane_gap = 4;
        };
        picker = {
          enable = true;
        };
        indent = {
          enable = true;
          animate = {
            enabled = false;
          };
        };
        explorer.enable = true;
        image.enable = isFullVariant;
      };
    };

    # Autocomplete with blink.cmp
    autocomplete.blink-cmp = {
      enable = true;
      setupOpts = {
        keymap.preset = "default";
        appearance.nerd_font_variant = "mono";
        completion = {
          documentation.auto_show = false;
        };
        signature.enabled = true;
        fuzzy.implementation = "prefer_rust_with_warning";
      };
    };
  };
}
