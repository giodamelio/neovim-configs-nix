-- Code comments
local nix = require("lib.nix")

return {
	nix.spec("comment.nvim", {
		event = "BufReadPost",
		config = true,
	}),
}
