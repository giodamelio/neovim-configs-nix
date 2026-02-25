-- Helper module for building lazy.nvim specs from Nix-managed plugins.
-- Reads plugin paths from vim.g.nix_plugins (set by nix-plugins.lua).

local M = {}

---@type table<string, string>
local paths = vim.g.nix_plugins or {}

--- Build a lazy.nvim spec base for a Nix-managed plugin.
--- Returns the spec table when plugin is available, empty table when not.
--- lazy.nvim ignores empty tables in spec arrays.
--- Pass additional spec keys (opts, config, keys, event, etc.) in `spec`.
---@param name string Plugin name (must match key in vim.g.nix_plugins)
---@param spec? table Additional lazy.nvim spec fields
---@return table
function M.spec(name, spec)
	local path = paths[name]
	-- Return empty table if plugin not available
	if not path then
		return {}
	end
	local base = {
		name = name,
		dir = path,
	}
	if spec then
		return vim.tbl_extend("force", base, spec)
	end
	return base
end

--- Check if a plugin is available in the Nix plugin map.
---@param name string Plugin name
---@return boolean
function M.has(name)
	return paths[name] ~= nil
end

--- Get the path for a plugin, or nil if not available.
---@param name string Plugin name
---@return string|nil
function M.path(name)
	return paths[name]
end

return M
