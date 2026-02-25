-- Neovim configuration entry point.
-- Loaded after vim.g.nix_plugins is set and rtp is configured.

-- Core vim settings (no plugin dependencies)
require("basic")

-- Initialize lazy.nvim
require("lazy").setup({
	-- Disable features that don't make sense for Nix-managed plugins
	rocks = { enabled = false },
	pkg = { enabled = false },
	install = { missing = false },
	change_detection = { enabled = false },
	checker = { enabled = false },

	-- Use performance defaults but don't reset rtp (lazy.nvim is on packpath via Nix)
	performance = {
		reset_packpath = false,
		rtp = {
			reset = false,
		},
	},

	-- Load all plugin specs from lua/plugins/
	spec = {
		{ import = "plugins" },
	},
})

-- GUI-specific settings (Neovide)
if vim.g.neovide then
	require("neovide")
end
