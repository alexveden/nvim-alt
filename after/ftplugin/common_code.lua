-- All code files specific options
-- use vim.bo - for local options
-- use vim.api.nvim_buf_set_keymap()
--

-- -- Special CamelCase or snake_case word moves (useful only in code)
-- for _, mode in pairs { 'n', 'o', 'x' } do
--   vim.api.nvim_buf_set_keymap(0, mode, 'w', "<cmd>lua require('spider').motion('w')<CR>", {})

--   vim.api.nvim_buf_set_keymap(0, mode, 'b', "<cmd>lua require('spider').motion('b')<CR>", {})
--   vim.api.nvim_buf_set_keymap(0, mode, 'ge', "<cmd>lua require('spider').motion('ge')<CR>", {})
-- end

vim.api.nvim_buf_set_keymap(0, 'n', '&', ':lua require("text_objects").argument_next()<CR>', { desc = 'jump to next argument' })

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jd', ":lua require('neogen').generate()<CR>", { desc = 'Generate doc-string' })

-- vim.api.nvim_buf_set_keymap(0,
--     "i",
--     "<C-k>",
--     ":lua require('lsp_signature').toggle_float_win()<CR>",
--     { desc = "Show signature" })

vim.api.nvim_buf_set_keymap(0, 'i', '<C-q>', "<esc>:lua error('Use norm<K> or insert<Ctrl-k> for code help')<cr>", { desc = 'Show signature' })
vim.api.nvim_buf_set_keymap(0, 'n', '<C-q>', ":lua error('Use norm<K> or insert<Ctrl-k> for code help')<cr>", { desc = 'Show signature' })

-- Prevent new line comments insertion
-- print("remove new line comments")
vim.opt.formatoptions:remove { 'c', 'r', 'o' }

-- vim.api.nvim_buf_set_keymap(0, 'n', '<C-PageUp>', '<cmd>norm[f<cr>', { desc = 'Jump next function above' })
-- vim.api.nvim_buf_set_keymap(0, 'n', '<C-PageDown>', '<cmd>norm]f<cr>', { desc = 'Jump next function below' })
-- vim.api.nvim_buf_set_keymap(0, 'n', '<C-PageUp>', 'zk', { desc = 'Jump fold up' })
-- vim.api.nvim_buf_set_keymap(0, 'n', '<C-PageDown>', 'zj', { desc = 'Jump fold down' })

-- -- Folding
--
-- function ToggleFoldRecursive()
--     if vim.fn.foldclosed('.') == -1 then
--         -- If the fold is open, close it recursively
--         vim.cmd('normal! zC')
--     else
--         -- If the fold is closed, open it recursively
--         vim.cmd('normal! zO')
--     end
-- end
-- vim.api.nvim_buf_set_keymap(0, 'n', 'z`', '<cmd>set foldlevel=0<CR>', { desc = 'foldlevel=0' })
-- vim.api.nvim_buf_set_keymap(0, 'n', 'z1', '<cmd>set foldlevel=1<CR>', { desc = 'foldlevel=1' })
-- vim.api.nvim_buf_set_keymap(0, 'n', 'z2', '<cmd>set foldlevel=2<CR>', { desc = 'foldlevel=2' })
-- vim.api.nvim_buf_set_keymap(0, 'n', 'z3', '<cmd>set foldlevel=3<CR>', { desc = 'foldlevel=3' })
-- vim.api.nvim_buf_set_keymap(0, 'n', 'za', ':lua ToggleFoldRecursive()<CR>', { desc = 'Toggle Fold recursively' })

