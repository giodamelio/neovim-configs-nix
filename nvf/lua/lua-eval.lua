-- Lua eval keybind for lua files.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.keymap.set({ "n", "v" }, "<localleader>e", function()
			Snacks.debug.run()
		end, { buffer = true, desc = "Evaluate Lua" })
	end,
})
