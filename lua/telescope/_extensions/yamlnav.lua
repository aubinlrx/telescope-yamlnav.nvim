local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	error("This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)")
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("telescope.utils")

-- Check if yaml-path as been installed
if 1 ~= vim.fn.executable("yaml-path") then
	utils.notify("aubinlrx.yaml_path", {
		msg = "Missing yaml-path binary",
		level = "ERROR",
	})
	return
end

local yaml_nav_command = require("yamlnav").yaml_path_list_command()

local yaml_list_paths = function(opts)
	opts = opts or { prefix = "en" }

	if vim.bo.filetype ~= "yaml" then
		utils.notify("aubinlrx.yaml_path", {
			msg = "Only works on .yml file",
			level = "ERROR",
		})
		return
	end

	local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
	local filepath = vim.api.nvim_buf_get_name(bufnr)

	-- [[ Split a string by separator ]]
	local function split(str, sep)
		local result = {}
		local regex = ("([^%s]+)"):format(sep)
		for each in str:gmatch(regex) do
			table.insert(result, each)
		end
		return result
	end

	table.insert(yaml_nav_command, filepath)

	local custom_finder = finders.new_oneshot_job(yaml_nav_command, {
		entry_maker = function(entry)
			local file = split(entry, " #")

			local value = {
				keys = file[1],
				lnum = file[2],
				filepath = filepath,
			}

			if value.keys == opts.prefix then
				return nil
			end

			return {
				value = value,
				display = string.gsub(value.keys, "^" .. opts.prefix .. ".?", ""),
				ordinal = value.keys,
			}
		end,
	})

	pickers
		.new(opts, {
			prompt_title = "colors",
			finder = custom_finder,
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.cmd("e " .. "+" .. selection.value.lnum .. " " .. selection.value.filepath)
				end)
				return true
			end,
		})
		:find()
end

return telescope.register_extension({
	exports = {
		yamlnav = yaml_list_paths,
	},
})
