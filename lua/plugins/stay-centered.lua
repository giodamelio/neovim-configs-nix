-- Keep cursor centered
local nix = require("lib.nix")

return {
	nix.spec("stay-centered.nvim", {
		event = "BufReadPost",
		config = true,
	}),
}
