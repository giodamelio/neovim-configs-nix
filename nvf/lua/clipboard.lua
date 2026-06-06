-- Clipboard provider selection.
--
-- Locally, Neovim auto-detects a provider (wl-copy on Wayland, etc.).
-- Over SSH there is no local clipboard tool reachable, so use OSC52 to copy
-- through the terminal emulator (WezTerm supports OSC52 write).
--
-- Paste does NOT use OSC52 read: WezTerm does not support OSC52 read by default
-- (it is gated behind `enable_osc52_clipboard_reading`), and pointing paste at
-- osc52.paste makes Neovim hang on every paste waiting for a reply that never
-- comes. Instead, read from Neovim's own register so `p` is instant and works
-- for anything yanked inside Neovim.
if os.getenv("SSH_TTY") or os.getenv("SSH_CONNECTION") then
	local osc52 = require("vim.ui.clipboard.osc52")

	local function paste()
		return vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("")
	end

	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = osc52.copy("+"),
			["*"] = osc52.copy("*"),
		},
		paste = {
			["+"] = paste,
			["*"] = paste,
		},
	}
end
