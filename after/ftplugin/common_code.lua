-- All code files specific options
-- use vim.bo - for local options
-- use vim.api.nvim_buf_set_keymap()
--

-- Special CamelCase or snake_case word moves (useful only in code)
for _, mode in pairs { 'n', 'o', 'x' } do
  vim.api.nvim_buf_set_keymap(0, mode, 'w', "<cmd>lua require('spider').motion('w')<CR>", {})
  vim.api.nvim_buf_set_keymap(0, mode, 'e', "<cmd>lua require('spider').motion('e')<CR>", {})
  vim.api.nvim_buf_set_keymap(0, mode, 'b', "<cmd>lua require('spider').motion('b')<CR>", {})
  vim.api.nvim_buf_set_keymap(0, mode, 'ge', "<cmd>lua require('spider').motion('ge')<CR>", {})
end

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

vim.api.nvim_buf_set_keymap(0, 'n', '<C-PageUp>', '<cmd>norm[f<cr>', { desc = 'Jump next function above' })
vim.api.nvim_buf_set_keymap(0, 'n', '<C-PageDown>', '<cmd>norm]f<cr>', { desc = 'Jump next function below' })

-- Folding
vim.api.nvim_buf_set_keymap(0, 'n', 'z`', '<cmd>set foldlevel=0<CR>', { desc = 'foldlevel=0' })
vim.api.nvim_buf_set_keymap(0, 'n', 'z1', '<cmd>set foldlevel=1<CR>', { desc = 'foldlevel=1' })
vim.api.nvim_buf_set_keymap(0, 'n', 'z2', '<cmd>set foldlevel=2<CR>', { desc = 'foldlevel=2' })
vim.api.nvim_buf_set_keymap(0, 'n', 'z3', '<cmd>set foldlevel=3<CR>', { desc = 'foldlevel=3' })

-- Code comments
vim.api.nvim_buf_set_keymap(0, 'n', '<C-_>', "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>", { desc = 'Comment line' })
vim.api.nvim_buf_set_keymap(0, 'v', '<C-_>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", { desc = 'Comment selection' })
