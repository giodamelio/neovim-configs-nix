-- Snacks: dashboard, picker, terminal, indent, notify, explorer, debug helpers
local nix = require("lib.nix")

return {
	nix.spec("snacks.nvim", {
		lazy = false, -- Dashboard needs to show at startup
		dependencies = { "trouble.nvim", "which-key.nvim" },
		config = function()
			local snacks = require("snacks")
			local wk = require("which-key")

			local snacks_config = {
				dashboard = {
					pane_gap = 4,
					preset = {
						keys = {
							{
								icon = " ",
								key = "f",
								desc = "Find File",
								action = ":lua Snacks.dashboard.pick('files')",
							},
							{
								icon = " ",
								key = "g",
								desc = "Find Text",
								action = ":lua Snacks.dashboard.pick('live_grep')",
							},
							{
								icon = " ",
								key = "r",
								desc = "Recent Files",
								action = ":lua Snacks.dashboard.pick('oldfiles')",
							},
							{
								icon = " ",
								key = "c",
								desc = "Config",
								action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.expand('$HOME/nixos-configs/nix/packages/neovim')})",
							},
							{
								icon = " ",
								key = "n",
								desc = "Nix Configs",
								action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.expand('$HOME/nixos-configs')})",
							},
							{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
							{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
						},
					},
					sections = {
						{ section = "header" },
						{ section = "keys", gap = 1, padding = 1 },
						{
							pane = 2,
							icon = " ",
							title = "Recent Files",
							section = "recent_files",
							indent = 2,
							padding = 1,
						},
						{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
						{
							pane = 2,
							icon = " ",
							title = "Git Status",
							section = "terminal",
							enabled = function()
								return snacks.git.get_root() ~= nil
							end,
							cmd = "git status --short --branch --renames",
							height = 5,
							padding = 1,
							ttl = 5 * 60,
							indent = 3,
						},
					},
				},
				picker = {
					config = function(opts)
						-- Add an open in trouble keybinding
						return vim.tbl_deep_extend("force", opts or {}, {
							actions = require("trouble.sources.snacks").actions,
							win = {
								input = {
									keys = {
										["<C-T>"] = {
											"trouble_open",
											mode = { "n", "i" },
										},
									},
								},
							},
						})
					end,
				},
				indent = {
					enable = true,
					animate = {
						enabled = false,
					},
				},
				keys = {
					config = function(opts)
						-- Add an open in trouble keybinding
						return vim.tbl_deep_extend("force", opts or {}, {
							keys = {
								{
									"<leader>/",
									function()
										snacks.terminal()
									end,
									desc = "Toggle Terminal",
								},
							},
						})
					end,
				},
			}

			-- Only enable image support in the full variant
			if vim.g.neovim_variant ~= "full" then
				snacks_config.image = {
					enable = false,
				}
			end

			snacks.setup(snacks_config)

			-- Show notification once per session when we first interact with nixos-configs
			vim.api.nvim_create_autocmd("CursorMoved", {
				pattern = vim.fn.expand("~/nixos-configs") .. "/*",
				once = true,
				callback = function()
					vim.defer_fn(function()
						snacks.notifier.notify("Use :NixInstall to apply configuration", {
							title = "Nix Configuration",
							level = "info",
							timeout = 5000,
							icon = "❄️",
						})
					end, 500) -- Delay to ensure snacks is fully loaded
				end,
			})

			-- Some helper functions for debugging
			-- selene: allow(multiple_statements)
			_G.dd = function(...)
				snacks.debug.inspect(...)
			end
			-- selene: allow(multiple_statements)
			_G.bt = function()
				snacks.debug.backtrace()
			end
			vim.print = _G.dd

			-- Find keybindings
			wk.add({
				{ "<leader>f", group = "Find" },
				{ "<leader>fG", group = "Git" },
			})

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
			vim.keymap.set("n", "<leader>fr", snacks.picker.recent, { desc = "Find recent files" })
			vim.keymap.set("n", "<leader>fc", snacks.picker.command_history, { desc = "Find recent commands" })
			vim.keymap.set("n", "<leader>fd", snacks.picker.diagnostics_buffer, { desc = "Find buffer diagnostics" })
			vim.keymap.set("n", "<leader>fD", snacks.picker.diagnostics, { desc = "Find all diagnostics" })
			vim.keymap.set("n", "<leader>fu", snacks.picker.undo, { desc = "Find undo history" })
			vim.keymap.set("n", "<leader>fr", snacks.picker.registers, { desc = "Find registers" })
			vim.keymap.set("n", "<leader>fr", snacks.picker.resume, { desc = "Resume last search" })
			vim.keymap.set("n", "<leader>fp", snacks.picker.pickers, { desc = "Find pickers" })
			vim.keymap.set("n", "<leader>fn", snacks.picker.notifications, { desc = "Find notifications" })
			vim.keymap.set("n", "<leader>fGb", snacks.picker.git_branches, { desc = "Find Git branches" })
			vim.keymap.set("n", "<leader>fGl", snacks.picker.git_log, { desc = "Find Git log" })
			vim.keymap.set("n", "<leader>fGL", snacks.picker.git_log_line, { desc = "Find Git log line" })
			vim.keymap.set("n", "<leader>fGs", snacks.picker.git_status, { desc = "Find Git status" })
			vim.keymap.set("n", "<leader>fGS", snacks.picker.git_stash, { desc = "Find Git stash" })
			vim.keymap.set("n", "<leader>fGd", snacks.picker.git_diff, { desc = "Find Git diff (hunks)" })
			vim.keymap.set("n", "<leader>fGf", snacks.picker.git_log_file, { desc = "Find Git log files" })
			vim.keymap.set("n", "<leader>fF", snacks.picker.smart, { desc = "Smart Finder" })
			vim.keymap.set("n", "<leader>fr", snacks.picker.resume, { desc = "Resume last search" })

			-- Terminal toggle
			vim.keymap.set("n", "<leader>/", snacks.terminal.toggle, { desc = "Toggle terminal" })
			vim.keymap.set("t", "<leader>/", snacks.terminal.toggle, { desc = "Toggle terminal" })

			-- Explorer
			vim.keymap.set("n", "<leader>`", snacks.explorer.open)

			-- LSP picker keybindings
			wk.add({
				{ "<leader>l", group = "LSP" },
			})

			vim.keymap.set("n", "<leader>lD", snacks.picker.lsp_definitions, { desc = "Show definitions" })
			vim.keymap.set("n", "<leader>ld", snacks.picker.lsp_declarations, { desc = "Show declarations" })
			vim.keymap.set("n", "<leader>li", snacks.picker.lsp_implementations, { desc = "Show implementations" })
			vim.keymap.set("n", "<leader>ls", snacks.picker.lsp_symbols, { desc = "Show buffer symbols" })
			vim.keymap.set("n", "<leader>lS", snacks.picker.lsp_workspace_symbols, { desc = "Show workspace symbols" })
			vim.keymap.set("n", "<leader>lr", snacks.picker.lsp_references, { desc = "Show references" })
			vim.keymap.set("n", "<leader>lt", snacks.picker.lsp_type_definitions, { desc = "Show type definition" })

			-- Snacks-dependent commands

			-- Files with hidden support
			vim.api.nvim_create_user_command("FilesHidden", function()
				files_hidden()
			end, { desc = "Find files including hidden ones" })

			-- Lua debug run command
			vim.api.nvim_create_user_command("LuaDebugRun", function()
				snacks.debug.run()
			end, { desc = "Run current Lua file/selection" })

			-- Lua eval command (only available for lua files)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "lua",
				callback = function()
					vim.api.nvim_buf_create_user_command(0, "LuaEval", function()
						snacks.debug.run()
					end, { desc = "Evaluate current Lua file/selection", range = true })
				end,
			})

			-- Lua-specific keybindings
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "lua",
				callback = function()
					vim.keymap.set(
						{ "n", "v" },
						"<localleader>e",
						"<cmd>LuaEval<cr>",
						{ buffer = true, desc = "Evaluate current file/selection" }
					)
				end,
			})

			-- Dashboard open
			vim.api.nvim_create_user_command("Dashboard", function()
				snacks.dashboard.open()
			end, { desc = "Open dashboard" })

			-- Nix Install (for nixos-configs directory) - only available in nixos-configs directory
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = vim.fn.expand("~/nixos-configs") .. "/*",
				callback = function()
					vim.api.nvim_buf_create_user_command(0, "NixInstall", function()
						snacks.terminal('nix-activate-config; echo "Press any key to close..."; read -n 1', {
							cwd = vim.fn.expand("~/nixos-configs"),
							win = {
								position = "bottom",
								height = 0.4,
							},
							auto_close = true,
						})
					end, { desc = "Install Nix configuration (nix-activate-config)" })
				end,
			})
		end,
	}),
}
