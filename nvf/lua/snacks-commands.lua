-- Snacks user commands.

-- Dashboard: open snacks dashboard
vim.api.nvim_create_user_command("Dashboard", function()
	Snacks.dashboard.open()
end, { desc = "Open dashboard" })

-- FilesHidden: find files including hidden ones
vim.api.nvim_create_user_command("FilesHidden", function()
	Snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Find files including hidden ones" })

-- LuaDebugRun: run current Lua file/selection
vim.api.nvim_create_user_command("LuaDebugRun", function()
	Snacks.debug.run()
end, { desc = "Run current Lua file/selection" })

-- LuaEval: evaluate Lua (only for lua files)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.api.nvim_buf_create_user_command(0, "LuaEval", function()
			Snacks.debug.run()
		end, { desc = "Evaluate current Lua file/selection", range = true })
	end,
})
