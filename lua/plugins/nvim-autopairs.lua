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

    local cmp_status_ok, cmp = pcall(require, 'cmp')
    if cmp_status_ok then
      cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done { tex = false })
    end
  end,

  -- use opts = {} for passing setup options
  -- this is equalent to setup({}) function
}
