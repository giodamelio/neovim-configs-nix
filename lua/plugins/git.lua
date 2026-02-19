-- Git: gitsigns + gitlinker + neogit
local gs = require("gitsigns")
local gsa = require("gitsigns.actions")
local gl = require("gitlinker")
local neogit = require("neogit")
local snacks = require("snacks")
local wk = require("which-key")

gs.setup({
	current_line_blame = true,
})

gl.setup({
	mapping = nil,
})

neogit.setup()

-- Git keybindings
wk.add({
	{ "<leader>g", group = "Git" },
})

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })
vim.keymap.set("n", "<leader>gb", function()
	snacks.git.blame_line()
end, { desc = "Blame Current Line" })
vim.keymap.set("n", "<leader>gn", function()
	gsa.next_hunk()
end, { desc = "Go to next hunk" })
vim.keymap.set("n", "<leader>gp", function()
	gsa.prev_hunk()
end, { desc = "Go to previous hunk" })
vim.keymap.set("n", "<leader>gr", function()
	gs.reset_hunk()
end, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gs", function()
	gs.stage_hunk()
end, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gu", function()
	gs.undo_stage_hunk()
end, { desc = "Unstage hunk" })
vim.keymap.set("n", "<leader>go", function()
	snacks.gitbrowse()
end, { desc = "Open current file in browser" })
vim.keymap.set("n", "<leader>gy", function()
	gl.link({
		-- GitLinker hard codes to the + register which doesn't work over ssh
		action = function(url)
			vim.fn.setreg('"', url)
		end,
		lstart = vim.api.nvim_buf_get_mark(0, "<")[1],
		lend = vim.api.nvim_buf_get_mark(0, ">")[1],
	})
end, { desc = "Copy permalink to clipboard" })

-- Visual mode git bindings
vim.keymap.set("v", "<leader>gr", function()
	gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Reset hunk" })
vim.keymap.set("v", "<leader>gs", function()
	gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Stage hunk" })
vim.keymap.set("v", "<leader>gy", function()
	gl.link({
		-- GitLinker hard codes to the + register which doesn't work over ssh
		action = function(url)
			vim.fn.setreg('"', url)
		end,
		lstart = vim.api.nvim_buf_get_mark(0, "<")[1],
		lend = vim.api.nvim_buf_get_mark(0, ">")[1],
	})
end, { desc = "Copy permalink to clipboard" })
