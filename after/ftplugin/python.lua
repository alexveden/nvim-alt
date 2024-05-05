-- Python specific options
-- use vim.bo - for local options
-- use vim.api.nvim_buf_set_keymap()

-- Include common settings for code 
vim.cmd('runtime! ftplugin/common_code.lua')

vim.api.nvim_buf_set_keymap(0,
    "n",
    "<leader>jf",
    ':lua require("text_objects").f_string_prepend()<CR>',
    { desc = "add f- prefix for string" })


