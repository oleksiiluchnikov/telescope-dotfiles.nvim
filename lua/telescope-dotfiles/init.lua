local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")

function M.configs(opts)
	opts = opts or {}

	local nvim_config_path = vim.fn.stdpath("config")
	local nvim_config_plugins_dir_path = nvim_config_path .. "/lua/user/plugins"

  ---Get the list of plugin configs
	---@return table<string, string>
	local function get_plugin_configs()
		local plugins = {}
		local path = nvim_config_plugins_dir_path .. "/init.lua"

		table.insert(plugins, "init")

		local file = io.open(path, "r")
		if file then
			for line in file:lines() do
				if line:find("require") and line:find("user.plugins") then
					local plugin = line:match("user.plugins.([A-Za-z0-9_%-]+)")
					if plugin then
						table.insert(plugins, plugin)
					end
				end
			end
			file:close()
		end
		return plugins
	end

	---@type table<string, string>
	local configs_list = get_plugin_configs()

  ---Open the selected config file
	local function enter(bufnr)
		local selected = actions_state.get_selected_entry()
		local path = nvim_config_plugins_dir_path .. "/" .. selected.value .. ".lua"

		local file = io.open(path, "r")
		if not file then
			path = nvim_config_plugins_dir_path .. "/" .. selected.value .. "/init.lua"
		end

		actions.close(bufnr)

		vim.cmd("edit " .. path)
	end

	pickers
		.new(opts, {
			prompt_title = "configs",
			finder = finders.new_table({
				results = configs_list,
				entry_maker = function(line)
					return {
						value = line,
						display = line,
						ordinal = line,
					}
				end,
			}),
			sorter = sorters.get_generic_fuzzy_sorter(),
			attach_mappings = function()
				actions.select_default:replace(enter)
				return true
			end,
		})
		:find()
end

return M
