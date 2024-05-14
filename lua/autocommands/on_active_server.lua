
-- Report active VIM window in order to make Alacritty links works
vim.api.nvim_create_autocmd('FocusGained', {
	desc = 'Reports actively focused vim server (for Alacritty links/files open)',
	callback = function()
	  local server = vim.fn.serverlist() or {""}
	  local f = assert(io.open("/tmp/nvim_active_window", "w"))
	  -- print(server[1])
    f:write(server[1])
    f:close()
	end,
})

-- always return empty
return {}
