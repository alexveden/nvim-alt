-- JS specific settings
-- Include common settings for code
vim.cmd 'runtime! ftplugin/common_code.lua'

vim.opt.colorcolumn = '100'
vim.api.nvim_buf_set_keymap(0, 'n', '<C-Left>', 'zc', { desc = 'Close fold', silent = true })
vim.api.nvim_buf_set_keymap(0, 'n', '<C-Right>', 'zo', { desc = 'Open Fold', silent = true })
