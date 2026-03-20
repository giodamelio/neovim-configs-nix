-- Snacks picker and dashboard integration for persisted.nvim sessions

local function get_sessions(limit)
	local persisted = require("persisted")
	local config = require("persisted.config")
	local sessions = {}
	local seen = {}

	for _, session in ipairs(persisted.list()) do
		local file = session:sub(#config.save_dir + 1, -5)
		local parts = vim.split(file, "@@", { plain = true })
		local dir = parts[1]:gsub("%%", "/")
		local branch = parts[2]
		local key = dir .. (branch or "")

		if not seen[key] then
			seen[key] = true
			local name = vim.fn.fnamemodify(dir, ":p:~")
			if branch then
				name = name .. " (" .. branch .. ")"
			end
			sessions[#sessions + 1] = { session = session, dir = dir, branch = branch, name = name }
			if limit and #sessions >= limit then
				break
			end
		end
	end

	return sessions
end

local function load_session(dir)
	vim.fn.chdir(dir)
	require("persisted").load()
end

-- Snacks picker command
vim.api.nvim_create_user_command("PersistedPickerLoad", function()
	local sessions = get_sessions()
	local items = {}
	for _, s in ipairs(sessions) do
		local content = vim.fn.readfile(s.session)
		items[#items + 1] = {
			text = s.name,
			session = s,
			preview = { text = table.concat(content, "\n"), ft = "vim" },
		}
	end

	Snacks.picker({
		title = "Sessions",
		items = items,
		preview = "preview",
		format = function(item, _ctx)
			local ret = {}
			local s = item.session
			table.insert(ret, { " ", hl = "SnacksPickerIcon" })
			table.insert(ret, { vim.fn.fnamemodify(s.dir, ":p:~"), hl = "SnacksPickerLabel" })
			if s.branch then
				table.insert(ret, { "  " .. s.branch, hl = "SnacksPickerComment" })
			end
			return ret
		end,
		confirm = function(picker, item)
			picker:close()
			if item and item.session then
				load_session(item.session.dir)
			end
		end,
	})
end, {})

-- Register as a snacks dashboard section (like recent_files, projects)
Snacks.dashboard.sections.persisted_dashboard_sessions = function(opts)
	return function()
		opts = opts or {}
		local limit = opts.limit or 5
		local ok, _ = pcall(require, "persisted")
		if not ok then
			return {}
		end

		local sessions = get_sessions(limit)
		local ret = {}
		for _, s in ipairs(sessions) do
			ret[#ret + 1] = {
				file = s.dir,
				icon = "directory",
				action = function()
					load_session(s.dir)
				end,
				autokey = true,
			}
		end
		return ret
	end
end
