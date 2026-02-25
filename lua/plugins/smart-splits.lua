-- Smart splits: pane navigation, resizing, and buffer swapping
local nix = require("lib.nix")

return {
	nix.spec("smart-splits.nvim", {
		event = "VeryLazy",
		keys = {
			-- Pane resize
			{
				"<A-h>",
				function()
					require("smart-splits").resize_left()
				end,
				desc = "Resize left",
			},
			{
				"<A-j>",
				function()
					require("smart-splits").resize_down()
				end,
				desc = "Resize down",
			},
			{
				"<A-k>",
				function()
					require("smart-splits").resize_up()
				end,
				desc = "Resize up",
			},
			{
				"<A-l>",
				function()
					require("smart-splits").resize_right()
				end,
				desc = "Resize right",
			},

			-- Moving between splits
			{
				"<C-h>",
				function()
					require("smart-splits").move_cursor_left()
				end,
				mode = { "n", "t", "v" },
				desc = "Move cursor left",
			},
			{
				"<C-j>",
				function()
					require("smart-splits").move_cursor_down()
				end,
				mode = { "n", "t", "v" },
				desc = "Move cursor down",
			},
			{
				"<C-k>",
				function()
					require("smart-splits").move_cursor_up()
				end,
				mode = { "n", "t", "v" },
				desc = "Move cursor up",
			},
			{
				"<C-l>",
				function()
					require("smart-splits").move_cursor_right()
				end,
				mode = { "n", "t", "v" },
				desc = "Move cursor right",
			},
			{
				"<C-\\>",
				function()
					require("smart-splits").move_cursor_previous()
				end,
				desc = "Move cursor previous",
			},

			-- Swapping buffers between windows
			{
				"<leader><leader>h",
				function()
					require("smart-splits").swap_buf_left()
				end,
				desc = "Swap buffer left",
			},
			{
				"<leader><leader>j",
				function()
					require("smart-splits").swap_buf_down()
				end,
				desc = "Swap buffer down",
			},
			{
				"<leader><leader>k",
				function()
					require("smart-splits").swap_buf_up()
				end,
				desc = "Swap buffer up",
			},
			{
				"<leader><leader>l",
				function()
					require("smart-splits").swap_buf_right()
				end,
				desc = "Swap buffer right",
			},
		},
	}),
}
