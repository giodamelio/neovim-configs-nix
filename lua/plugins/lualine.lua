-- Status bar
local lualine = require("lualine")
local default_config = lualine.get_config()

local config = vim.tbl_deep_extend("force", default_config, {
	sections = {
		lualine_c = { "filename", "lsp_progress" },
	},
	winbar = {
		lualine_c = {
			{
				"navic",
				color_correction = nil,
				navic_opts = nil,
			},
		},
	},
	-- Show some help when the tabline is open, I always forget the keys...
	tabline = {
		lualine_a = { { "tabs", mode = 2 } },
		lualine_x = { '"[next tab] gt, [prev tab] gT, [close tab] :tabclose"' },
	},
})
lualine.setup(config)

-- Hide mode display in the command bar since lualine shows it
vim.opt.showmode = false

-- Only show the tabline if there is more then one tab
vim.opt.showtabline = 1
