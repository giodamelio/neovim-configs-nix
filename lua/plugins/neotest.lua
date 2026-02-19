-- NeoTest: test running framework
local neotest = require("neotest")
local wk = require("which-key")

neotest.setup({
	adapters = {
		require("neotest-rust"),
		require("neotest-elixir"),
		require("neotest-go"),
		require("neotest-deno"),
		require("neotest-rspec"),
		require("neotest-python"),
	},
})

-- Testing keybindings
wk.add({
	{ "<leader>t", group = "Testing" },
})

vim.keymap.set("n", "<leader>tf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run tests in file" })
vim.keymap.set("n", "<leader>tp", function()
	neotest.output_panel.toggle()
end, { desc = "Toggle output panel" })
vim.keymap.set("n", "<leader>ts", function()
	neotest.summary.toggle()
end, { desc = "Toggle summary" })
vim.keymap.set("n", "<leader>tt", function()
	neotest.run.run()
end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tw", function()
	neotest.watch.toggle(vim.fn.expand("%"))
end, { desc = "Watch tests in file" })
vim.keymap.set("n", "<leader>ta", function()
	neotest.run.attach()
end, { desc = "Attach to running test" })
vim.keymap.set("n", "<leader>tl", function()
	neotest.run.run_last()
end, { desc = "Run last test" })
