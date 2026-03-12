# Keybindings configuration.
# Global keymaps via vim.keymaps and complex keymaps via luaConfigRC.
{
  lib,
  variant ? "full",
  ...
}:
let
  isFullVariant = variant == "full";
in
{
  config.vim = {
    # Global keymaps
    keymaps = [
      # Buffer switching
      {
        key = "<leader><Tab>";
        mode = "n";
        action = "<cmd>b#<cr>";
        desc = "Switch to last buffer";
      }

      # LSP keybindings
      {
        key = "K";
        mode = "n";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        desc = "Show hover docs";
      }
      {
        key = "<leader>ll";
        mode = "n";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        desc = "Show code actions";
      }
      {
        key = "<leader>lf";
        mode = "n";
        action = "<cmd>lua vim.lsp.buf.format()<cr>";
        desc = "Format buffer";
      }
      {
        key = "<leader>lR";
        mode = "n";
        action = "<cmd>lua vim.lsp.buf.rename()<cr>";
        desc = "Rename under cursor";
      }

      # Trouble diagnostics
      {
        key = "<leader>dd";
        mode = "n";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        desc = "Document diagnostics";
      }
      {
        key = "<leader>dl";
        mode = "n";
        action = "<cmd>Trouble lsp toggle<cr>";
        desc = "LSP toggle";
      }
      {
        key = "<leader>de";
        mode = "n";
        action = "<cmd>Trouble lsp_definitions toggle<cr>";
        desc = "Definitions";
      }
      {
        key = "<leader>di";
        mode = "n";
        action = "<cmd>Trouble lsp_implementations toggle<cr>";
        desc = "Implementations";
      }
      {
        key = "<leader>dr";
        mode = "n";
        action = "<cmd>Trouble lsp_references toggle<cr>";
        desc = "References";
      }
      {
        key = "<leader>dn";
        mode = "n";
        action = "<cmd>lua require('trouble').next({ skip_groups = true, jump = true })<cr>";
        desc = "Next diagnostic";
      }
      {
        key = "<leader>dp";
        mode = "n";
        action = "<cmd>lua require('trouble').prev({ skip_groups = true, jump = true })<cr>";
        desc = "Previous diagnostic";
      }
    ];

    # Complex keymaps via luaConfigRC
    luaConfigRC = {
      # Which-key group registrations
      which-key-groups = ''
        local wk = require("which-key")
        wk.add({
          { "<leader>f", group = "Find" },
          { "<leader>fG", group = "Git" },
          { "<leader>l", group = "LSP" },
          { "<leader>d", group = "Diagnostics" },
          { "<leader>g", group = "Git" },
          { "<leader>t", group = "Testing" },
          { "<leader>o", group = "Other" },
          { "<leader><leader><Tab>", group = "Grapple" },
          ${if isFullVariant then ''{ "<leader>c", group = "Claude" },'' else ""}
        })
      '';

      # Snacks picker keybindings
      snacks-keybindings = ''
        local snacks = require("snacks")

        -- Find keybindings
        local function files_hidden()
          snacks.picker.files({
            finder = "files",
            format = "file",
            show_empty = true,
            hidden = true,
            ignored = true,
            follow = false,
            supports_live = true,
          })
        end

        vim.keymap.set("n", "<leader>f?", snacks.picker.help, { desc = "Find help tags" })
        vim.keymap.set("n", "<leader>fb", snacks.picker.buffers, { desc = "Find buffer" })
        vim.keymap.set("n", "<leader>ff", snacks.picker.files, { desc = "Find file" })
        vim.keymap.set("n", "<leader>fg", snacks.picker.grep, { desc = "Find line in file" })
        vim.keymap.set("n", "<leader>fh", files_hidden, { desc = "Find file (including hidden)" })
        vim.keymap.set("n", "<leader>fm", snacks.picker.marks, { desc = "Find marks" })
        vim.keymap.set("n", "<leader>fr", snacks.picker.resume, { desc = "Resume last search" })
        vim.keymap.set("n", "<leader>fR", snacks.picker.recent, { desc = "Find recent files" })
        vim.keymap.set("n", "<leader>fc", snacks.picker.command_history, { desc = "Find recent commands" })
        vim.keymap.set("n", "<leader>f:", snacks.picker.commands, { desc = "Find recent commands" })
        vim.keymap.set("n", "<leader>fd", snacks.picker.diagnostics_buffer, { desc = "Find buffer diagnostics" })
        vim.keymap.set("n", "<leader>fD", snacks.picker.diagnostics, { desc = "Find all diagnostics" })
        vim.keymap.set("n", "<leader>fu", snacks.picker.undo, { desc = "Find undo history" })
        vim.keymap.set("n", "<leader>fp", snacks.picker.pickers, { desc = "Find pickers" })
        vim.keymap.set("n", "<leader>fn", snacks.picker.notifications, { desc = "Find notifications" })
        vim.keymap.set("n", "<leader>fF", snacks.picker.smart, { desc = "Smart Finder" })

        -- Git find keybindings
        vim.keymap.set("n", "<leader>fGb", snacks.picker.git_branches, { desc = "Find Git branches" })
        vim.keymap.set("n", "<leader>fGl", snacks.picker.git_log, { desc = "Find Git log" })
        vim.keymap.set("n", "<leader>fGL", snacks.picker.git_log_line, { desc = "Find Git log line" })
        vim.keymap.set("n", "<leader>fGs", snacks.picker.git_status, { desc = "Find Git status" })
        vim.keymap.set("n", "<leader>fGS", snacks.picker.git_stash, { desc = "Find Git stash" })
        vim.keymap.set("n", "<leader>fGd", snacks.picker.git_diff, { desc = "Find Git diff (hunks)" })
        vim.keymap.set("n", "<leader>fGf", snacks.picker.git_log_file, { desc = "Find Git log files" })

        -- LSP picker keybindings
        vim.keymap.set("n", "<leader>lD", snacks.picker.lsp_definitions, { desc = "Show definitions" })
        vim.keymap.set("n", "<leader>ld", snacks.picker.lsp_declarations, { desc = "Show declarations" })
        vim.keymap.set("n", "<leader>li", snacks.picker.lsp_implementations, { desc = "Show implementations" })
        vim.keymap.set("n", "<leader>ls", snacks.picker.lsp_symbols, { desc = "Show buffer symbols" })
        vim.keymap.set("n", "<leader>lS", snacks.picker.lsp_workspace_symbols, { desc = "Show workspace symbols" })
        vim.keymap.set("n", "<leader>lr", snacks.picker.lsp_references, { desc = "Show references" })
        vim.keymap.set("n", "<leader>lt", snacks.picker.lsp_type_definitions, { desc = "Show type definition" })

        -- Terminal toggle
        vim.keymap.set("n", "<leader>/", snacks.terminal.toggle, { desc = "Toggle terminal" })
        vim.keymap.set("t", "<leader>/", snacks.terminal.toggle, { desc = "Toggle terminal" })

        -- Explorer
        vim.keymap.set("n", "<leader>`", snacks.explorer.open)

        -- Debug helpers
        _G.dd = function(...) snacks.debug.inspect(...) end
        _G.bt = function() snacks.debug.backtrace() end
        vim.print = _G.dd
      '';

      # Git keybindings
      git-keybindings = ''
        -- Only set up git keybindings if gitsigns is available
        local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
        local snacks = require("snacks")

        if gitsigns_ok then
          vim.keymap.set("n", "<leader>gb", function() snacks.git.blame_line() end, { desc = "Blame current line" })
          vim.keymap.set("n", "<leader>gn", gitsigns.next_hunk, { desc = "Next hunk" })
          vim.keymap.set("n", "<leader>gp", gitsigns.prev_hunk, { desc = "Previous hunk" })
          vim.keymap.set({ "n", "v" }, "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
          vim.keymap.set({ "n", "v" }, "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
          vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Unstage hunk" })
          vim.keymap.set("n", "<leader>go", function() snacks.gitbrowse() end, { desc = "Open file in browser" })
          vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit" })

          -- Gitlinker keybindings
          local gitlinker_ok, gitlinker = pcall(require, "gitlinker")
          if gitlinker_ok then
            vim.keymap.set({ "n", "v" }, "<leader>gy", function()
              gitlinker.link({
                action = function(url)
                  vim.fn.setreg('"', url)
                end,
                lstart = vim.api.nvim_buf_get_mark(0, "<")[1],
                lend = vim.api.nvim_buf_get_mark(0, ">")[1],
              })
            end, { desc = "Copy permalink" })
          end
        end
      '';

      # Smart splits keybindings
      smart-splits-keybindings = ''
        local splits = require("smart-splits")

        -- Resize
        vim.keymap.set("n", "<A-h>", splits.resize_left, { desc = "Resize left" })
        vim.keymap.set("n", "<A-j>", splits.resize_down, { desc = "Resize down" })
        vim.keymap.set("n", "<A-k>", splits.resize_up, { desc = "Resize up" })
        vim.keymap.set("n", "<A-l>", splits.resize_right, { desc = "Resize right" })

        -- Move cursor between splits
        vim.keymap.set({ "n", "t", "v" }, "<C-h>", splits.move_cursor_left, { desc = "Move to left split" })
        vim.keymap.set({ "n", "t", "v" }, "<C-j>", splits.move_cursor_down, { desc = "Move to below split" })
        vim.keymap.set({ "n", "t", "v" }, "<C-k>", splits.move_cursor_up, { desc = "Move to above split" })
        vim.keymap.set({ "n", "t", "v" }, "<C-l>", splits.move_cursor_right, { desc = "Move to right split" })
        vim.keymap.set("n", "<C-\\>", splits.move_cursor_previous, { desc = "Move to previous split" })

        -- Swap buffers
        vim.keymap.set("n", "<leader><leader>h", splits.swap_buf_left, { desc = "Swap buffer left" })
        vim.keymap.set("n", "<leader><leader>j", splits.swap_buf_down, { desc = "Swap buffer down" })
        vim.keymap.set("n", "<leader><leader>k", splits.swap_buf_up, { desc = "Swap buffer up" })
        vim.keymap.set("n", "<leader><leader>l", splits.swap_buf_right, { desc = "Swap buffer right" })
      '';

      # Treefmt keybinding
      treefmt-keybinding = ''
        vim.keymap.set("n", "<localleader>f", function()
          local treefmt = vim.fn.exepath("treefmt")
          if treefmt ~= "" then
            vim.cmd("!treefmt --quiet " .. vim.fn.expand("%"))
            vim.cmd("edit")
          else
            vim.notify("treefmt not found", vim.log.levels.WARN)
          end
        end, { desc = "Format with treefmt" })
      '';

      # Lua eval keybinding (filetype-specific)
      lua-eval-keybinding = ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "lua",
          callback = function()
            vim.keymap.set({ "n", "v" }, "<localleader>e", function()
              require("snacks").debug.run()
            end, { buffer = true, desc = "Evaluate Lua" })
          end,
        })
      '';

      # NixInstall command for nixos-configs
      nix-install-command = ''
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
          pattern = vim.fn.expand("~/nixos-configs") .. "/*",
          callback = function()
            vim.api.nvim_buf_create_user_command(0, "NixInstall", function()
              require("snacks").terminal('nix-activate-config; echo "Press any key to close..."; read -n 1', {
                cwd = vim.fn.expand("~/nixos-configs"),
                win = {
                  position = "bottom",
                  height = 0.4,
                },
                auto_close = true,
              })
            end, { desc = "Install Nix configuration" })
          end,
        })

        -- Show notification when entering nixos-configs
        vim.api.nvim_create_autocmd("CursorMoved", {
          pattern = vim.fn.expand("~/nixos-configs") .. "/*",
          once = true,
          callback = function()
            vim.defer_fn(function()
              require("snacks").notifier.notify("Use :NixInstall to apply configuration", {
                title = "Nix Configuration",
                level = "info",
                timeout = 5000,
              })
            end, 500)
          end,
        })
      '';

      # User commands
      user-commands = ''
        -- BdeleteAll command
        vim.api.nvim_create_user_command("BdeleteAll", function()
          local current = vim.api.nvim_get_current_buf()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
              vim.api.nvim_buf_delete(buf, { force = false })
            end
          end
        end, { desc = "Delete all buffers except current" })

        -- LspCapabilities command
        vim.api.nvim_create_user_command("LspCapabilities", function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          for _, client in ipairs(clients) do
            print(vim.inspect(client.server_capabilities))
          end
        end, { desc = "Show LSP capabilities" })

        -- Dashboard command
        vim.api.nvim_create_user_command("Dashboard", function()
          require("snacks").dashboard.open()
        end, { desc = "Open dashboard" })

        -- Files with hidden support
        vim.api.nvim_create_user_command("FilesHidden", function()
          require("snacks").picker.files({
            finder = "files",
            format = "file",
            show_empty = true,
            hidden = true,
            ignored = true,
            follow = false,
            supports_live = true,
          })
        end, { desc = "Find files including hidden ones" })

        -- Lua debug commands
        vim.api.nvim_create_user_command("LuaDebugRun", function()
          require("snacks").debug.run()
        end, { desc = "Run current Lua file/selection" })

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "lua",
          callback = function()
            vim.api.nvim_buf_create_user_command(0, "LuaEval", function()
              require("snacks").debug.run()
            end, { desc = "Evaluate current Lua file/selection", range = true })
          end,
        })
      '';

      # Neotest setup and keybindings (full variant only)
      neotest-config = lib.mkIf isFullVariant ''
        -- Setup neotest with adapters
        require("neotest").setup({
          adapters = {
            require("neotest-rust"),
            require("neotest-elixir"),
            require("neotest-go"),
            require("neotest-deno"),
            require("neotest-rspec"),
            require("neotest-python"),
          },
        })

        -- Neotest keybindings
        vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run() end, { desc = "Run nearest test" })
        vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
        vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle summary" })
        vim.keymap.set("n", "<leader>tp", function() require("neotest").output_panel.toggle() end, { desc = "Toggle output panel" })
        vim.keymap.set("n", "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, { desc = "Watch tests" })
        vim.keymap.set("n", "<leader>ta", function() require("neotest").run.attach() end, { desc = "Attach to test" })
        vim.keymap.set("n", "<leader>tl", function() require("neotest").run.run_last() end, { desc = "Run last test" })
      '';
    };
  };
}
