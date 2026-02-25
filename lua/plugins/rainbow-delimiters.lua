-- Rainbow delimiters (rainbow parentheses)
local nix = require("lib.nix")

return {
	nix.spec("rainbow-delimiters.nvim", {
		event = "BufReadPost",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")
			local rainbowsetup = require("rainbow-delimiters.setup")

			rainbowsetup({
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			})
		end,
	}),
}
