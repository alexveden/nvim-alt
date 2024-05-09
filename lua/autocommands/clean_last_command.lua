-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Clean last command after some timeout
vim.api.nvim_create_autocmd('CmdLineLeave', {
  desc = 'Clears cmd line from last command after timeout',
  callback = function()
    local function clean_command_line()
      print ' '
    end

    local timer = vim.loop.new_timer()
    -- Delay 2000ms and 0 means "do not repeat"
    timer:start(2000, 0, vim.schedule_wrap(clean_command_line))
  end,
})

-- always return empty
return {}
