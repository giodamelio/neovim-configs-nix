-- Elixir Tools
require("elixir").setup({
	nextls = {
		enable = false,
		cmd = "nextls",
		init_options = {
			experimental = {
				completions = {
					enable = true,
				},
			},
		},
	},
	elixirls = { enable = false },
	projectionist = { enable = true },
})
