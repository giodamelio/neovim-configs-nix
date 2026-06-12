-- review.nvim only exports comments to the clipboard; review.export
-- .generate_markdown() returns the string directly, avoiding a clipboard
-- round-trip (the provider is OSC52 / write-only).
local M = {}

local function review_markdown()
	local ok, export = pcall(require, "review.export")
	if not ok then
		vim.notify("review.nvim is not loaded (open a review first)", vim.log.levels.ERROR)
		return nil
	end
	local md = export.generate_markdown()
	if not md or md == "" then
		vim.notify("No review comments to send", vim.log.levels.WARN)
		return nil
	end
	return md
end

function M.to_codecompanion()
	local md = review_markdown()
	if not md then
		return
	end
	local cc = require("codecompanion")
	local chat = cc.last_chat() or cc.chat()
	if not chat then
		vim.notify("Could not open a CodeCompanion chat", vim.log.levels.ERROR)
		return
	end
	chat:add_buf_message({
		role = "user",
		content = "Here is my code review. Please help me address these comments:\n\n" .. md,
	})
	chat.ui:open()
end

-- claudecode communicates via file @-mentions, not raw text, so write the
-- markdown to a file and mention that.
function M.to_claudecode()
	local md = review_markdown()
	if not md then
		return
	end
	local path = vim.fs.joinpath(vim.fn.stdpath("cache"), "review-export.md")
	local f = io.open(path, "w")
	if not f then
		vim.notify("Could not write review export to " .. path, vim.log.levels.ERROR)
		return
	end
	f:write(md)
	f:close()

	local ok, claudecode = pcall(require, "claudecode")
	if not ok then
		vim.notify("claudecode.nvim is not loaded (toggle Claude first)", vim.log.levels.ERROR)
		return
	end
	claudecode.send_at_mention(path, nil, nil, "review.nvim")
	vim.notify("Sent review to Claude Code", vim.log.levels.INFO)
end

_G.AIReview = M
