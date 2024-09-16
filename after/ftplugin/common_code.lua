-- All code files specific options
-- use vim.bo - for local options
-- use vim.api.nvim_buf_set_keymap()
--

-- Special CamelCase or snake_case word moves (useful only in code)
for _, mode in pairs({"n", "o", "x"}) do
    vim.api.nvim_buf_set_keymap(0, mode, "w", "<cmd>lua require('spider').motion('w')<CR>", {})
    vim.api.nvim_buf_set_keymap(0, mode, "e", "<cmd>lua require('spider').motion('e')<CR>", {})
    vim.api.nvim_buf_set_keymap(0, mode , "b", "<cmd>lua require('spider').motion('b')<CR>", {})
    vim.api.nvim_buf_set_keymap(0, mode, "ge", "<cmd>lua require('spider').motion('ge')<CR>", {})
end

vim.api.nvim_buf_set_keymap(0,
    "n",
    "&",
    ':lua require("text_objects").argument_next()<CR>',
    { desc = "jump to next argument" })

vim.api.nvim_buf_set_keymap(0,
    "n",
    "<leader>jd",
    ":lua require('neogen').generate()<CR>",
    { desc = "Generate doc-string" })

-- vim.api.nvim_buf_set_keymap(0,
--     "i",
--     "<C-k>",
--     ":lua require('lsp_signature').toggle_float_win()<CR>",
--     { desc = "Show signature" })

vim.api.nvim_buf_set_keymap(0,
    "i",
    "<C-q>",
    "<esc>:lua error('Use norm<K> or insert<Ctrl-k> for code help')<cr>",
    { desc = "Show signature" })

vim.api.nvim_buf_set_keymap(0,
    "n",
    "<C-q>",
    ":lua error('Use norm<K> or insert<Ctrl-k> for code help')<cr>",
    { desc = "Show signature" })

-- Prevent new line comments insertion 
-- print("remove new line comments")
vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
