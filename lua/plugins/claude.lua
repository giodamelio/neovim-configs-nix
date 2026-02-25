-- Claude Code: AI assistant integration
local nix = require("lib.nix")

return {
	nix.spec("claudecode.nvim", {
		cmd = "ClaudeCode",
		dependencies = { "which-key.nvim" },
		keys = {
			{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
			{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude", mode = "v" },
		},
		config = function()
			local wk = require("which-key")

			require("claudecode").setup()

			wk.add({
				{ "<leader>c", group = "Claude Code" },
			})

			-- Set Claude Code tree add keymap only for file browser filetypes
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "NvimTree", "neo-tree", "oil", "minifiles" },
				callback = function()
					vim.keymap.set(
						"n",
						"<leader>cs",
						"<cmd>ClaudeCodeTreeAdd<cr>",
						{ desc = "Add file", buffer = true }
					)
					vim.keymap.set("n", "<leader>cS", function()
						vim.cmd("ClaudeCodeTreeAdd")
						vim.cmd("ClaudeCodeFocus")
						-- Wait 100ms for focus to complete, then send enter
						vim.defer_fn(function()
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
						end, 100)
					end, { desc = "Add file and send", buffer = true })
				end,
			})

			-- Claude Code tree add and send command
			vim.api.nvim_create_user_command("ClaudeTreeAddSend", function()
				vim.cmd("ClaudeCodeTreeAdd")
				vim.cmd("ClaudeCodeFocus")
				-- Wait 100ms for focus to complete, then send enter
				vim.defer_fn(function()
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
				end, 100)
			end, { desc = "Add file to Claude and send" })
		end,
	}),
}
