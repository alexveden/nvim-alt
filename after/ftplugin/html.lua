vim.opt.colorcolumn = '200'
vim.api.nvim_buf_set_keymap(0, 'n', '<C-Left>', 'zc', { desc = 'Close fold', silent = true })
vim.api.nvim_buf_set_keymap(0, 'n', '<C-Right>', 'zo', { desc = 'Open Fold', silent = true })
