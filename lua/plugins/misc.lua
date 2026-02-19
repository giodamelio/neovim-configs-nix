-- Miscellaneous commands and keybinds with no specific plugin dependency

-- Fresh start: Close all buffers but stay open
vim.api.nvim_create_user_command("BdeleteAll", function()
	vim.cmd("bufdo bdelete")
end, { desc = "Close all buffers, but stay open" })

-- LSP Capabilities display
vim.api.nvim_create_user_command("LspCapabilities", function()
	local snacks = require("snacks")

	local function get_lsp_capabilities_data()
		local content_lines = {}
		table.insert(content_lines, "# LSP Capabilities")
		table.insert(content_lines, "")

		local clients = vim.lsp.get_clients({ bufnr = 0 })

		if #clients == 0 then
			table.insert(content_lines, "No LSP clients are currently running.")
		else
			for _, client in pairs(clients) do
				if client.name ~= "null-ls" then
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
						table.sort(capAsList) -- sorts alphabetically
						for _, cap in ipairs(capAsList) do
							table.insert(content_lines, cap)
						end
					end
					table.insert(content_lines, "")
				end
			end
		end

		return content_lines
	end

	local content_lines = get_lsp_capabilities_data()

	snacks.win({
		text = table.concat(content_lines, "\n"),
		ft = "markdown",
		title = "LSP Capabilities",
		wo = {
			wrap = true,
		},
	})
end, { desc = "Show LSP server capabilities" })

-- Switch to last buffer
vim.keymap.set("n", "<leader><Tab>", "<cmd>edit #<cr>", { desc = "Switch to last buffer" })
