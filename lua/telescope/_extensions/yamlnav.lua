local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	error("This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)")
end

local pickers = telescope.pickers
local finders = telescope.finders
local conf = telescope.config.values
local actions = telescope.actions
local action_state = telescope.actions.action_state
local utils = telescope.utils

-- Check if yaml-path as been installed
if 1 ~= vim.fn.executable("yaml-path") then
	utils.notify("aubinlrx.yaml_path", {
		msg = "Missing yaml-path binary",
		level = "ERROR",
	})
	return
end

local yaml_nav = {}

local yaml_nav_command = { "yaml-path", "list", "--line" }

yaml_nav.list_paths = function(opts)
	opts = opts or {}

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

			if value.keys == "en" then
				return nil
			end

			return {
				value = value,
				display = string.gsub(value.keys, "^en.?", ""),
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

return require("telescope").register_extension({
  exports = {
    yamlnav = yaml_nav.list_paths
  }
})
