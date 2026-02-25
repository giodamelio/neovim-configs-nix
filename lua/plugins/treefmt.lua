-- Treefmt: format files with treefmt (pure Lua commands, no plugin)
-- This runs at load time, not through a lazy.nvim spec

if vim.fn.executable("treefmt") == 1 then
	vim.api.nvim_create_user_command("Treefmt", function(opts)
		local snacks = require("snacks")
		local args = opts.args
		local cmd

		if args == "" then
			-- Format current file
			local current_file = vim.fn.expand("%:p")
			if current_file == "" then
				snacks.notifier.notify("No file to format", { level = "warn" })
				return
			end
			cmd = "treefmt " .. vim.fn.shellescape(current_file)
		else
			-- Format specified paths
			local paths = {}
			for path in string.gmatch(args, "%S+") do
				table.insert(paths, vim.fn.shellescape(path))
			end
			cmd = "treefmt " .. table.concat(paths, " ")
		end

		local output = vim.fn.system(cmd)
		if vim.v.shell_error == 0 then
			if output ~= "" then
				print(output)
			end
		else
			snacks.notifier.notify("Treefmt failed: " .. output, { level = "error" })
		end
	end, {
		nargs = "*",
		desc = "Format a file with treefmt",
		complete = function(arg_lead)
			return vim.fn.getcompletion(arg_lead, "file")
		end,
	})

	-- TreefmtAll command for entire project
	vim.api.nvim_create_user_command("TreefmtAll", function()
		local snacks = require("snacks")
		local output = vim.fn.system("treefmt")
		if vim.v.shell_error == 0 then
			if output ~= "" then
				print(output)
			end
		else
			snacks.notifier.notify("Treefmt failed: " .. output, { level = "error" })
		end
	end, { desc = "Format all files with treefmt" })
end

-- Local leader keybinding for formatting current file with treefmt
vim.keymap.set("n", "<localleader>f", "<cmd>Treefmt<cr>", { desc = "Format current file with treefmt" })

-- Return empty table so lazy.nvim doesn't complain
return {}
