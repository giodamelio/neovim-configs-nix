-- Jujutsu VCS integration
local nix = require("lib.nix")

return {
	nix.spec("jj.nvim", {
		config = true,
	}),
}
