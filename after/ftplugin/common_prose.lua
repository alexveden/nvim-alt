-- Plain text specific options
-- use vim.bo - for local options
-- use vim.api.nvim_buf_set_keymap()
--
vim.g["pencil#wrapModeDefault"] = "soft"
vim.cmd "let g:pencil#conceallevel = 0"
vim.cmd "SoftPencil"

-- Disable spell check for prose by default
vim.wo.spell = true


-- Jump between headers
vim.api.nvim_buf_set_keymap(0, 'n', '<C-PageUp>', '<cmd>norm[[<cr>', { desc = 'Jump next header above' })
vim.api.nvim_buf_set_keymap(0, 'n', '<C-PageDown>', '<cmd>norm]]<cr>', { desc = 'Jump next header below' })

