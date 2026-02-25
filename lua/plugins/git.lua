-- Git: gitsigns + gitlinker + neogit + diffview
local nix = require("lib.nix")

return {
	-- Gitsigns: show git changes in sign column
	nix.spec("gitsigns.nvim", {
		event = "BufReadPost",
		dependencies = { "which-key.nvim", "snacks.nvim" },
		opts = {
			current_line_blame = true,
		},
		keys = {
			{
				"<leader>gb",
				function()
					require("snacks").git.blame_line()
				end,
				desc = "Blame Current Line",
			},
			{
				"<leader>gn",
				function()
					require("gitsigns.actions").next_hunk()
				end,
				desc = "Go to next hunk",
			},
			{
				"<leader>gp",
				function()
					require("gitsigns.actions").prev_hunk()
				end,
				desc = "Go to previous hunk",
			},
			{
				"<leader>gr",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = "Reset hunk",
			},
			{
				"<leader>gs",
				function()
					require("gitsigns").stage_hunk()
				end,
				desc = "Stage hunk",
			},
			{
				"<leader>gu",
				function()
					require("gitsigns").undo_stage_hunk()
				end,
				desc = "Unstage hunk",
			},
			{
				"<leader>go",
				function()
					require("snacks").gitbrowse()
				end,
				desc = "Open current file in browser",
			},
			{
				"<leader>gy",
				function()
					require("gitlinker").link({
						-- GitLinker hard codes to the + register which doesn't work over ssh
						action = function(url)
							vim.fn.setreg('"', url)
						end,
						lstart = vim.api.nvim_buf_get_mark(0, "<")[1],
						lend = vim.api.nvim_buf_get_mark(0, ">")[1],
					})
				end,
				desc = "Copy permalink to clipboard",
			},
			-- Visual mode bindings
			{
				"<leader>gr",
				function()
					require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				mode = "v",
				desc = "Reset hunk",
			},
			{
				"<leader>gs",
				function()
					require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				mode = "v",
				desc = "Stage hunk",
			},
			{
				"<leader>gy",
				function()
					require("gitlinker").link({
						-- GitLinker hard codes to the + register which doesn't work over ssh
						action = function(url)
							vim.fn.setreg('"', url)
						end,
						lstart = vim.api.nvim_buf_get_mark(0, "<")[1],
						lend = vim.api.nvim_buf_get_mark(0, ">")[1],
					})
				end,
				mode = "v",
				desc = "Copy permalink to clipboard",
			},
		},
		config = function(_, opts)
			require("gitsigns").setup(opts)
			require("which-key").add({
				{ "<leader>g", group = "Git" },
			})
		end,
	}),

	-- GitLinker: generate permalinks
	nix.spec("gitlinker.nvim", {
		event = "BufReadPost",
		opts = {
			mapping = nil,
		},
	}),

	-- Neogit: magit-like git interface
	nix.spec("neogit", {
		cmd = "Neogit",
		dependencies = { "plenary.nvim", "diffview.nvim" },
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit UI" },
		},
		config = true,
	}),

	-- Diffview: diff viewer for neogit
	nix.spec("diffview.nvim", {
		lazy = true,
		config = true,
	}),
}
