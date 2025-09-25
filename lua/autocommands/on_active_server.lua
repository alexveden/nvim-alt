-- Report active VIM window in order to make Alacritty links works
vim.api.nvim_create_autocmd('FocusGained', {
  desc = 'Reports actively focused vim server (for Alacritty links/files open)',
  callback = function()
    local user = vim.env.USER
    local server = vim.fn.serverlist() or { '' }
    local f = assert(io.open('/tmp/nvim_active_window_' .. user, 'w'))
    -- print(server[1])
    f:write(server[1])
    f:close()

    f = assert(io.open('/tmp/nvim_active_cwd_' .. user, 'w'))
    f:write(vim.fn.getcwd())
    f:close()
  end,
})

-- always return empty
return {}
