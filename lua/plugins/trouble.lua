-- Trouble: pretty lists of diagnostics, references, etc.
local trouble = require("trouble")
local wk = require("which-key")

trouble.setup()

-- Diagnostics/Trouble keybindings
wk.add({
	{ "<leader>d", group = "Diagnostics/Trouble" },
})

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
