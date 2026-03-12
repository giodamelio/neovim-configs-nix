-- Treefmt integration - format commands and keybindings.
if vim.fn.executable("treefmt") == 1 then
	vim.api.nvim_create_user_command("Treefmt", function(opts)
		local args = opts.args
		local cmd
		if args == "" then
			local current_file = vim.fn.expand("%:p")
			if current_file == "" then
				Snacks.notifier.notify("No file to format", { level = "warn" })
				return
			end
			cmd = "treefmt " .. vim.fn.shellescape(current_file)
		else
			local paths = {}
			for path in string.gmatch(args, "%S+") do
				table.insert(paths, vim.fn.shellescape(path))
			end
			cmd = "treefmt " .. table.concat(paths, " ")
		end
		local output = vim.fn.system(cmd)
		if vim.v.shell_error == 0 then
			vim.cmd("edit")
			if output ~= "" then
				print(output)
			end
		else
			Snacks.notifier.notify("Treefmt failed: " .. output, { level = "error" })
		end
	end, {
		nargs = "*",
		desc = "Format file with treefmt",
		complete = function(arg_lead)
			return vim.fn.getcompletion(arg_lead, "file")
		end,
	})

	vim.api.nvim_create_user_command("TreefmtAll", function()
		local output = vim.fn.system("treefmt")
		if vim.v.shell_error == 0 then
			if output ~= "" then
				print(output)
			end
		else
			Snacks.notifier.notify("Treefmt failed: " .. output, { level = "error" })
		end
	end, { desc = "Format all files with treefmt" })

	vim.keymap.set("n", "<localleader>f", "<cmd>Treefmt<cr>", { desc = "Format with treefmt" })
end
