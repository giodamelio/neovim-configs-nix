local nix = require("lib.nix")

return {
	nix.spec("which-key.nvim", {
		event = "VeryLazy",
		config = true,
	}),
}
