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
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local pos = vim.api.nvim_get_current_line():match("^%s*"):len() + 1

	local command = { "yaml-path", "get", filepath, "-c", pos, "-l", line }
	local result = vim.fn.systemlist(command)

	if result[1] == nil or vim.startswith(result[1], "Error") then
		vim.notify("No result for line:" .. line .. " and pos:" .. pos)
		return
	end

	result = string.gsub(result[1], "en.", "")

	vim.fn.setreg("@", result)
	vim.fn.setreg("*", result)
	vim.fn.setreg("+", result)

	vim.notify("Yaml path copied! " .. result, vim.log.levels.INFO)
end
vim.api.nvim_create_user_command("YamlNavCopy", M.copy_path, { nargs = 0 })

return M
