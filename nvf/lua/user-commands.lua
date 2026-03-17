-- User commands for core functionality.

-- BdeleteAll: close all buffers except current
vim.api.nvim_create_user_command("Bdelete", function()
	Snacks.bufdelete.delete()
end, { desc = "Delete the current buffer" })

vim.api.nvim_create_user_command("BdeleteOther", function()
	Snacks.bufdelete.other()
end, { desc = "Delete all buffers except current" })

vim.api.nvim_create_user_command("BdeleteAll", function()
	Snacks.bufdelete.all()
end, { desc = "Delete all buffers" })

-- LspCapabilities: show LSP server capabilities in snacks window
vim.api.nvim_create_user_command("LspCapabilities", function()
	local content_lines = { "# LSP Capabilities", "" }
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		table.insert(content_lines, "No LSP clients are currently running.")
	else
		for _, client in pairs(clients) do
			table.insert(content_lines, "## " .. client.name)
			table.insert(content_lines, "")
			local capAsList = {}
			for key, value in pairs(client.server_capabilities) do
				if value and key:find("Provider") then
					local capability = key:gsub("Provider$", "")
					table.insert(capAsList, "- " .. capability)
				end
			end
			if #capAsList == 0 then
				table.insert(content_lines, "No capabilities found.")
			else
				table.sort(capAsList)
				for _, cap in ipairs(capAsList) do
					table.insert(content_lines, cap)
				end
			end
			table.insert(content_lines, "")
		end
	end
	Snacks.win({
		text = table.concat(content_lines, "\n"),
		ft = "markdown",
		title = "LSP Capabilities",
		wo = { wrap = true },
	})
end, { desc = "Show LSP server capabilities" })
