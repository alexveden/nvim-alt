-- Plain text specific options
-- use vim.bo - for local options
-- use vim.api.nvim_buf_set_keymap()
--
vim.g["pencil#wrapModeDefault"] = "soft"
vim.cmd "let g:pencil#conceallevel = 0"
vim.cmd "SoftPencil"

-- Disable spell check for prose by default
vim.wo.spell = false

