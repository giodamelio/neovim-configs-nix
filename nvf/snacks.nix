# Snacks.nvim - dashboard, picker, terminal, indent, explorer.
{
  pkgs,
  variant ? "full",
  ...
}: let
  inherit (import ./lib.nix) nmapLua mapLua snacks snacksPicker snacksPickerOpts;
  isFullVariant = variant == "full";
in {
  config.vim = {
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
            {section = "header";}
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
        notifier.enable = true;
        image.enable = isFullVariant;
      };
    };

    # Which-key group for git pickers
    binds.whichKey.register."<leader>fG" = "Git";
    keymaps = [
      # === Snacks Picker: Find ===
      (nmapLua "<leader>f?" (snacksPicker "help") "Find help tags")
      (nmapLua "<leader>fb" (snacksPicker "buffers") "Find buffer")
      (nmapLua "<leader>ff" (snacksPicker "files") "Find file")
      (nmapLua "<leader>fg" (snacksPicker "grep") "Find text")
      (
        nmapLua "<leader>fh" (snacksPickerOpts "files" "{ hidden = true, ignored = true }")
        "Find file (hidden)"
      )
      (nmapLua "<leader>fm" (snacksPicker "marks") "Find marks")
      (nmapLua "<leader>fr" (snacksPicker "resume") "Resume last search")
      (nmapLua "<leader>fR" (snacksPicker "recent") "Find recent files")
      (nmapLua "<leader>fc" (snacksPicker "command_history") "Find recent commands")
      (nmapLua "<leader>fd" (snacksPicker "diagnostics_buffer") "Find buffer diagnostics")
      (nmapLua "<leader>fD" (snacksPicker "diagnostics") "Find all diagnostics")
      (nmapLua "<leader>fu" (snacksPicker "undo") "Find undo history")
      (nmapLua "<leader>fp" (snacksPicker "pickers") "Find pickers")
      (nmapLua "<leader>fn" (snacksPicker "notifications") "Find notifications")
      (nmapLua "<leader>fF" (snacksPicker "smart") "Smart Finder")

      # === Snacks Picker: Git ===
      (nmapLua "<leader>fGb" (snacksPicker "git_branches") "Find Git branches")
      (nmapLua "<leader>fGl" (snacksPicker "git_log") "Find Git log")
      (nmapLua "<leader>fGL" (snacksPicker "git_log_line") "Find Git log line")
      (nmapLua "<leader>fGs" (snacksPicker "git_status") "Find Git status")
      (nmapLua "<leader>fGS" (snacksPicker "git_stash") "Find Git stash")
      (nmapLua "<leader>fGd" (snacksPicker "git_diff") "Find Git diff")
      (nmapLua "<leader>fGf" (snacksPicker "git_log_file") "Find Git log files")

      # === Snacks: Terminal & Explorer ===
      (mapLua ["n" "t"] "<leader>/" (snacks "terminal.toggle()") "Toggle terminal")
      (nmapLua "<leader>`" (snacks "explorer.open()") "Open explorer")
    ];

    luaConfigRC = {
      snacks-commands = builtins.readFile ./lua/snacks-commands.lua;
      lua-eval = builtins.readFile ./lua/lua-eval.lua;
    };

    extraPackages = with pkgs; [ripgrep fd];
  };
}
