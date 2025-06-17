return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local opts = {
      enable_check_bracket_line = true,
      ignored_next_char = "[%w%.]" -- will ignore alphanumeric and `.` symbol
    }
    local npairs = require 'nvim-autopairs'

    npairs.setup(opts)
  end,

  -- use opts = {} for passing setup options
  -- this is equalent to setup({}) function
}
