-- NixOS configuration helpers - NixInstall command.
local nixos_configs_path = vim.fn.expand("~/nixos-configs")

-- Notification when entering nixos-configs
vim.api.nvim_create_autocmd("CursorMoved", {
	pattern = nixos_configs_path .. "/*",
	once = true,
	callback = function()
		vim.defer_fn(function()
			Snacks.notifier.notify("Use :NixInstall to apply configuration", {
				title = "Nix Configuration",
				level = "info",
				timeout = 5000,
			})
		end, 500)
	end,
})

-- NixInstall command (buffer-local for nixos-configs)
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = nixos_configs_path .. "/*",
	callback = function()
		vim.api.nvim_buf_create_user_command(0, "NixInstall", function()
			Snacks.terminal('nix-activate-config; echo "Press any key to close..."; read -n 1', {
				cwd = nixos_configs_path,
				win = { position = "bottom", height = 0.4 },
				auto_close = true,
			})
		end, { desc = "Install Nix configuration" })
	end,
})
