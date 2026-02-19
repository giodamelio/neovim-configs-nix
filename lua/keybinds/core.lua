local wk = require("which-key")

local smart_split = require("smart-splits")
local snacks = require("snacks")

-- Which-key group registrations
wk.add({
	{ "<leader>f", group = "Find" },
	{ "<leader>fG", group = "Git" },
	{ "<leader><leader><Tab>", group = "Grapple" },
	{ "<leader>d", group = "Diagnostics/Trouble" },
	{ "<leader>l", group = "LSP" },
	{ "<leader>o", group = "Other files" },
	{ "<leader>g", group = "Git" },
})

-- Misc top level bindings
vim.keymap.set("n", "<leader><Tab>", "<cmd>edit #<cr>", { desc = "Switch to last buffer" })
vim.keymap.set("n", "<leader>/", snacks.terminal.toggle, { desc = "Toggle terminal" })
vim.keymap.set("t", "<leader>/", snacks.terminal.toggle, { desc = "Toggle terminal" })

-- Pane Navigation with Smart Splits
vim.keymap.set("n", "<A-h>", smart_split.resize_left)
vim.keymap.set("n", "<A-j>", smart_split.resize_down)
vim.keymap.set("n", "<A-k>", smart_split.resize_up)
vim.keymap.set("n", "<A-l>", smart_split.resize_right)

-- Moving between splits
vim.keymap.set({ "n", "t", "v" }, "<C-h>", smart_split.move_cursor_left)
vim.keymap.set({ "n", "t", "v" }, "<C-j>", smart_split.move_cursor_down)
vim.keymap.set({ "n", "t", "v" }, "<C-k>", smart_split.move_cursor_up)
vim.keymap.set({ "n", "t", "v" }, "<C-l>", smart_split.move_cursor_right)
vim.keymap.set("n", "<C-\\>", smart_split.move_cursor_previous)

-- Swapping buffers between windows
vim.keymap.set("n", "<leader><leader>h", smart_split.swap_buf_left)
vim.keymap.set("n", "<leader><leader>j", smart_split.swap_buf_down)
vim.keymap.set("n", "<leader><leader>k", smart_split.swap_buf_up)
vim.keymap.set("n", "<leader><leader>l", smart_split.swap_buf_right)

-- Open explorer
vim.keymap.set("n", "<leader>`", snacks.explorer.open)

-- Fuzzy Finding
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

-- Get around important files easily
vim.keymap.set("n", "<leader><leader><Tab>m", "<cmd>Grapple toggle<cr>", { desc = "Grapple toggle tag" })
vim.keymap.set("n", "<leader><leader><Tab>M", "<cmd>Grapple toggle_tags<cr>", { desc = "Grapple open tags window" })
vim.keymap.set("n", "<leader><leader><Tab>n", "<cmd>Grapple cycle_tags next<cr>", { desc = "Grapple cycle next tag" })
vim.keymap.set(
	"n",
	"<leader><leader><Tab>p",
	"<cmd>Grapple cycle_tags prev<cr>",
	{ desc = "Grapple cycle previous tag" }
)

-- Diagnostics and Trouble.nvim
vim.keymap.set(
	"n",
	"<leader>dd",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ desc = "Trouble document diagnostics" }
)
vim.keymap.set("n", "<leader>dl", "<cmd>Trouble lsp toggle<cr>", { desc = "Trouble document diagnostics" })
vim.keymap.set("n", "<leader>de", "<cmd>Trouble lsp_definitions toggle<cr>", { desc = "Trouble definitions" })
vim.keymap.set("n", "<leader>di", "<cmd>Trouble lsp_implementations toggle<cr>", { desc = "Trouble implementations" })
vim.keymap.set("n", "<leader>dr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "Trouble references" })
vim.keymap.set("n", "<leader>dn", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<leader>dp", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic" })

-- Language Server
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover docs" })
vim.keymap.set("n", "<leader>lD", snacks.picker.lsp_definitions, { desc = "Show definitions" })
vim.keymap.set("n", "<leader>ld", snacks.picker.lsp_declarations, { desc = "Show declarations" })
vim.keymap.set("n", "<leader>li", snacks.picker.lsp_implementations, { desc = "Show implementations" })
vim.keymap.set("n", "<leader>ll", vim.lsp.buf.code_action, { desc = "Show code actions" })
vim.keymap.set("n", "<leader>ls", snacks.picker.lsp_symbols, { desc = "Show buffer symbols" })
vim.keymap.set("n", "<leader>lS", snacks.picker.lsp_workspace_symbols, { desc = "Show workspace symbols" })
vim.keymap.set("n", "<leader>lr", snacks.picker.lsp_references, { desc = "Show references" })
vim.keymap.set("n", "<leader>lt", snacks.picker.lsp_type_definitions, { desc = "Show type definition" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })
vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, { desc = "Rename under cursor" })

-- Navigate to other files
vim.keymap.set("n", "<leader>oc", "<cmd>OtherClear<cr>", { desc = "Clear the internal reference to other file" })
vim.keymap.set("n", "<leader>oo", "<cmd>Other<cr>", { desc = "Open the the other file" })
vim.keymap.set("n", "<leader>os", "<cmd>OtherSplit<cr>", { desc = "Open the the other file in a horizontal split" })
vim.keymap.set("n", "<leader>ov", "<cmd>OtherVSplit<cr>", { desc = "Open the the other file in a vertical split" })

-- Git keybindings
local gs = require("gitsigns")
local gsa = require("gitsigns.actions")
local gl = require("gitlinker")

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
		-- action = gla.clipboard,
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
		-- action = gla.clipboard,
		action = function(url)
			vim.fn.setreg('"', url)
		end,
		lstart = vim.api.nvim_buf_get_mark(0, "<")[1],
		lend = vim.api.nvim_buf_get_mark(0, ">")[1],
	})
end, { desc = "Copy permalink to clipboard" })

-- Local leader keybinding for formatting current file with treefmt
vim.keymap.set("n", "<localleader>f", "<cmd>Treefmt<cr>", { desc = "Format current file with treefmt" })

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
