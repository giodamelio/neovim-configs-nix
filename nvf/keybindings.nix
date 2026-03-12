# Keybindings configuration using NVF's vim.keymaps system.
{
  lib,
  variant ? "full",
  ...
}:
let
  inherit (import ./lib.nix)
    cmd
    nmap
    nmapLua
    mapLua
    snacks
    snacksPicker
    snacksPickerOpts
    ;

  isFullVariant = variant == "full";
  isLightVariant = variant == "light";
  hasGit = isFullVariant || isLightVariant;
in
{
  config.vim = {
    # Which-key group registrations
    binds.whichKey.register = {
      "<leader>f" = "Find";
      "<leader>fG" = "Git";
      "<leader>l" = "LSP";
      "<leader>d" = "Diagnostics";
      "<leader>t" = "Testing";
      "<leader>o" = "Other";
      "<leader><leader>" = "Swap/Grapple";
    }
    // lib.optionalAttrs hasGit {
      "<leader>g" = "Git";
    }
    // lib.optionalAttrs isFullVariant {
      "<leader>c" = "Claude";
    };

    # All keymaps in one place
    keymaps = [
      # === Buffer ===
      (nmap "<leader><Tab>" (cmd "b#") "Switch to last buffer")

      # === LSP ===
      (nmapLua "K" "vim.lsp.buf.hover()" "Show hover docs")
      (nmapLua "<leader>ll" "vim.lsp.buf.code_action()" "Show code actions")
      (nmapLua "<leader>lf" "vim.lsp.buf.format()" "Format buffer")
      (nmapLua "<leader>lR" "vim.lsp.buf.rename()" "Rename under cursor")

      # === Trouble Diagnostics ===
      (nmap "<leader>dd" (cmd "Trouble diagnostics toggle") "Document diagnostics")
      (nmap "<leader>dl" (cmd "Trouble lsp toggle") "LSP toggle")
      (nmap "<leader>de" (cmd "Trouble lsp_definitions toggle") "Definitions")
      (nmap "<leader>di" (cmd "Trouble lsp_implementations toggle") "Implementations")
      (nmap "<leader>dr" (cmd "Trouble lsp_references toggle") "References")
      (nmapLua "<leader>dn" "require('trouble').next({ skip_groups = true, jump = true })"
        "Next diagnostic"
      )
      (nmapLua "<leader>dp" "require('trouble').prev({ skip_groups = true, jump = true })"
        "Previous diagnostic"
      )

      # === Snacks Picker: Find ===
      (nmapLua "<leader>f?" (snacksPicker "help") "Find help tags")
      (nmapLua "<leader>fb" (snacksPicker "buffers") "Find buffer")
      (nmapLua "<leader>ff" (snacksPicker "files") "Find file")
      (nmapLua "<leader>fg" (snacksPicker "grep") "Find text")
      (nmapLua "<leader>fh" (snacksPickerOpts "files" "{ hidden = true, ignored = true }")
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

      # === Snacks Picker: LSP ===
      (nmapLua "<leader>lD" (snacksPicker "lsp_definitions") "Show definitions")
      (nmapLua "<leader>ld" (snacksPicker "lsp_declarations") "Show declarations")
      (nmapLua "<leader>li" (snacksPicker "lsp_implementations") "Show implementations")
      (nmapLua "<leader>ls" (snacksPicker "lsp_symbols") "Show buffer symbols")
      (nmapLua "<leader>lS" (snacksPicker "lsp_workspace_symbols") "Show workspace symbols")
      (nmapLua "<leader>lr" (snacksPicker "lsp_references") "Show references")
      (nmapLua "<leader>lt" (snacksPicker "lsp_type_definitions") "Show type definition")

      # === Snacks: Terminal & Explorer ===
      (mapLua [ "n" "t" ] "<leader>/" (snacks "terminal.toggle()") "Toggle terminal")
      (nmapLua "<leader>`" (snacks "explorer.open()") "Open explorer")

      # === Smart Splits ===
      (nmapLua "<A-h>" "require('smart-splits').resize_left()" "Resize left")
      (nmapLua "<A-j>" "require('smart-splits').resize_down()" "Resize down")
      (nmapLua "<A-k>" "require('smart-splits').resize_up()" "Resize up")
      (nmapLua "<A-l>" "require('smart-splits').resize_right()" "Resize right")
      (mapLua [ "n" "t" "v" ] "<C-h>" "require('smart-splits').move_cursor_left()" "Move to left split")
      (mapLua [ "n" "t" "v" ] "<C-j>" "require('smart-splits').move_cursor_down()" "Move to below split")
      (mapLua [ "n" "t" "v" ] "<C-k>" "require('smart-splits').move_cursor_up()" "Move to above split")
      (mapLua [ "n" "t" "v" ] "<C-l>" "require('smart-splits').move_cursor_right()" "Move to right split")
      (nmapLua "<C-\\>" "require('smart-splits').move_cursor_previous()" "Move to previous split")
      (nmapLua "<leader><leader>h" "require('smart-splits').swap_buf_left()" "Swap buffer left")
      (nmapLua "<leader><leader>j" "require('smart-splits').swap_buf_down()" "Swap buffer down")
      (nmapLua "<leader><leader>k" "require('smart-splits').swap_buf_up()" "Swap buffer up")
      (nmapLua "<leader><leader>l" "require('smart-splits').swap_buf_right()" "Swap buffer right")

      # === Grapple ===
      (nmapLua "<leader><leader><Tab>" "require('grapple').toggle_tags()" "Grapple tags")
      (nmapLua "<leader><leader>a" "require('grapple').tag()" "Grapple add")
      (nmapLua "<leader><leader>d" "require('grapple').untag()" "Grapple remove")
      (nmapLua "<leader><leader>1" "require('grapple').select({ index = 1 })" "Grapple 1")
      (nmapLua "<leader><leader>2" "require('grapple').select({ index = 2 })" "Grapple 2")
      (nmapLua "<leader><leader>3" "require('grapple').select({ index = 3 })" "Grapple 3")
      (nmapLua "<leader><leader>4" "require('grapple').select({ index = 4 })" "Grapple 4")
    ]
    # === Git keybindings (full + light) ===
    ++ lib.optionals hasGit [
      (nmapLua "<leader>gb" "Snacks.git.blame_line()" "Blame current line")
      (nmapLua "<leader>gn" "require('gitsigns').next_hunk()" "Next hunk")
      (nmapLua "<leader>gp" "require('gitsigns').prev_hunk()" "Previous hunk")
      (mapLua [ "n" "v" ] "<leader>gr" "require('gitsigns').reset_hunk()" "Reset hunk")
      (mapLua [ "n" "v" ] "<leader>gs" "require('gitsigns').stage_hunk()" "Stage hunk")
      (nmapLua "<leader>gu" "require('gitsigns').undo_stage_hunk()" "Unstage hunk")
      (nmapLua "<leader>go" "Snacks.gitbrowse()" "Open file in browser")
      (nmap "<leader>gg" (cmd "Neogit") "Open Neogit")
    ]
    # === Neotest keybindings (full only) ===
    ++ lib.optionals isFullVariant [
      (nmapLua "<leader>tt" "require('neotest').run.run()" "Run nearest test")
      (nmapLua "<leader>tf" "require('neotest').run.run(vim.fn.expand('%'))" "Run file tests")
      (nmapLua "<leader>ts" "require('neotest').summary.toggle()" "Toggle summary")
      (nmapLua "<leader>tp" "require('neotest').output_panel.toggle()" "Toggle output panel")
      (nmapLua "<leader>tw" "require('neotest').watch.toggle(vim.fn.expand('%'))" "Watch tests")
      (nmapLua "<leader>ta" "require('neotest').run.attach()" "Attach to test")
      (nmapLua "<leader>tl" "require('neotest').run.run_last()" "Run last test")
    ];

    # Minimal luaConfigRC for things that can't be keymaps
    luaConfigRC = {
      # Treefmt keybinding (needs shell command)
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

      # Debug helpers
      debug-helpers = ''
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd
      '';

      # User commands
      user-commands = ''
        vim.api.nvim_create_user_command("BdeleteAll", function()
          local current = vim.api.nvim_get_current_buf()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
              vim.api.nvim_buf_delete(buf, { force = false })
            end
          end
        end, { desc = "Delete all buffers except current" })

        vim.api.nvim_create_user_command("LspCapabilities", function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          for _, client in ipairs(clients) do
            print(vim.inspect(client.server_capabilities))
          end
        end, { desc = "Show LSP capabilities" })

        vim.api.nvim_create_user_command("Dashboard", function()
          Snacks.dashboard.open()
        end, { desc = "Open dashboard" })
      '';

      # Gitlinker setup (full + light)
      gitlinker-keybindings = lib.mkIf hasGit ''
        local gitlinker_ok, gitlinker = pcall(require, "gitlinker")
        if gitlinker_ok then
          vim.keymap.set({ "n", "v" }, "<leader>gy", function()
            gitlinker.link({
              action = function(url) vim.fn.setreg('"', url) end,
              lstart = vim.api.nvim_buf_get_mark(0, "<")[1],
              lend = vim.api.nvim_buf_get_mark(0, ">")[1],
            })
          end, { desc = "Copy permalink" })
        end
      '';

      # Lua eval for lua files
      lua-eval = ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "lua",
          callback = function()
            vim.keymap.set({ "n", "v" }, "<localleader>e", function()
              Snacks.debug.run()
            end, { buffer = true, desc = "Evaluate Lua" })
          end,
        })
      '';

      # Neotest setup (full only)
      neotest-setup = lib.mkIf isFullVariant ''
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
      '';

      # NixInstall command for nixos-configs
      nix-install = ''
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
          pattern = vim.fn.expand("~/nixos-configs") .. "/*",
          callback = function()
            vim.api.nvim_buf_create_user_command(0, "NixInstall", function()
              Snacks.terminal('nix-activate-config; echo "Press any key to close..."; read -n 1', {
                cwd = vim.fn.expand("~/nixos-configs"),
                win = { position = "bottom", height = 0.4 },
                auto_close = true,
              })
            end, { desc = "Install Nix configuration" })
          end,
        })
      '';
    };
  };
}
