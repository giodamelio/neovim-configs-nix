-- Grapple: quick file tagging and navigation
local wk = require("which-key")

wk.add({
	{ "<leader><leader><Tab>", group = "Grapple" },
})

vim.keymap.set("n", "<leader><leader><Tab>m", "<cmd>Grapple toggle<cr>", { desc = "Grapple toggle tag" })
vim.keymap.set("n", "<leader><leader><Tab>M", "<cmd>Grapple toggle_tags<cr>", { desc = "Grapple open tags window" })
vim.keymap.set("n", "<leader><leader><Tab>n", "<cmd>Grapple cycle_tags next<cr>", { desc = "Grapple cycle next tag" })
vim.keymap.set(
	"n",
	"<leader><leader><Tab>p",
	"<cmd>Grapple cycle_tags prev<cr>",
	{ desc = "Grapple cycle previous tag" }
)
