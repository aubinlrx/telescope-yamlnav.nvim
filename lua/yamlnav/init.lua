local M = {}

M.yaml_path_list_command = function(opts)
	opts = opts or {}
	return { "yaml-path", "list", "--line" }
end

M.yaml_path_get_command = function(opts)
	opts = opts or {}
	return { "yaml-path", "get" }
end

M.copy_path = function()
	if vim.bo.filetype ~= "yaml" then
		vim.notify("Only works on .yml file", vim.log.levels.INFO)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	local cursor = vim.api.nvim_win_get_cursor(0)

	local result = vim.fn.systemlist({ "yaml-path", "get", filepath, "-c", cursor[2], "-l", cursor[1] })

	if result[0] == nil then
		return
	end

	vim.fn.setreg("@", result)
	vim.fn.setreg("*", result)
	vim.fn.setreg("+", result)

	vim.notify("Yaml path copied!", vim.log.levels.INFO)
end

return M
