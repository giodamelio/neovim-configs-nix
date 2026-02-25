-- Elixir Tools
local nix = require("lib.nix")

return {
	nix.spec("elixir-tools.nvim", {
		ft = { "elixir", "heex", "eex" },
		opts = {
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
		},
	}),
}
