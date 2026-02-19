-- Micro variant plugin configuration
-- Minimal snacks.nvim setup with fuzzy finding, dashboard, and terminal

require("mini.icons").setup()

local snacks = require("snacks")

snacks.setup({
	dashboard = {
		preset = {
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
			},
		},
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			{ section = "recent_files", icon = " ", title = "Recent Files", indent = 2, padding = 1 },
		},
	},
	picker = {},
	indent = {
		enable = true,
		animate = {
			enabled = false,
		},
	},
})

-- Keybinds (no which-key, just plain vim.keymap.set)
local map = vim.keymap.set

-- Find
map("n", "<leader>ff", function()
	snacks.picker.files()
end, { desc = "Find files" })
map("n", "<leader>fg", function()
	snacks.picker.grep()
end, { desc = "Live grep" })
map("n", "<leader>fb", function()
	snacks.picker.buffers()
end, { desc = "Find buffers" })
map("n", "<leader>fr", function()
	snacks.picker.recent()
end, { desc = "Recent files" })
map("n", "<leader>f?", function()
	snacks.picker.help()
end, { desc = "Help tags" })

-- Terminal
map("n", "<leader>/", function()
	snacks.terminal()
end, { desc = "Toggle Terminal" })
