vim.cmd 'runtime! ftplugin/common_code.lua'

vim.bo.commentstring = '//%s'
vim.opt.colorcolumn = '100'

-- TODO: makeprog and c3 error format + add test + other file different path
--set makeprg=c3c\ test\ --test
--set efm=%s\|%f\|%l\|%c\|%m

vim.bo.tabstop = 4

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>fl', ":lua require('c3fzf').c3fzf()<CR>", { desc = '[L]anguage symbols for C3' })

