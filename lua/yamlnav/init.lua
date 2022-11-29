local M = {}

M.yaml_path_list_command = function(opts)
	opts = opts or {}
	return { "yaml-path", "list", "--line" }
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
	local path = vim.fn.systemlist(command)[1]

	if path == nil or vim.startswith(path, "Error") then
		vim.notify("No result for line:" .. line .. " and pos:" .. pos)
		return
	end

	vim.fn.setreg("@", path)
	vim.fn.setreg("*", path)
	vim.fn.setreg("+", path)

	vim.notify("Yaml path copied! " .. path, vim.log.levels.INFO)
end
vim.api.nvim_create_user_command("YamlNavCopy", M.copy_path, { nargs = 0 })

return M
