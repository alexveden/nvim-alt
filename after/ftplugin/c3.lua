vim.cmd 'runtime! ftplugin/common_code.lua'

vim.bo.commentstring = '//%s'
vim.opt.colorcolumn = '100'

-- TODO: makeprog and c3 error format + add test + other file different path
--set makeprg=c3c\ test\ --test
--set efm=%s\|%f\|%l\|%c\|%m

vim.bo.tabstop = 4

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lh', ":lua require('c3fzf').c3fzf()<CR>", { desc = '[H]elp for C3' })

vim.api.nvim_buf_set_keymap(0, "n", "<leader>lf", "", {
    callback = function ()
        vim.cmd('silent !/home/ubertrader/code/c3tools/build/c3fmt %')
        vim.cmd("checktime")
    end,
    noremap = true,  -- Disable recursive mapping
    silent = true,   -- Suppress command-line output
    desc="Format C3 code with c3fmt"
})
