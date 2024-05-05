-- All code files specific options
-- use vim.bo - for local options
-- use vim.api.nvim_buf_set_keymap()
--
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
