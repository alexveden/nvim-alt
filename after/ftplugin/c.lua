-- C specific options
-- use vim.bo - for local options
-- use vim.api.nvim_buf_set_keymap()

-- Include common settings for code
vim.cmd 'runtime! ftplugin/common_code.lua'

vim.opt.colorcolumn = '100'

-- Disables CEX module function calls highlighting as property
-- ie. App.namespace.~~my_func()~~ - my_func highlighed as property
vim.api.nvim_set_hl(0, '@lsp.type.property.c', {})
vim.api.nvim_set_hl(0, '@lsp.type.macro.c', {})
vim.api.nvim_set_hl(0, '@lsp.type.c', {link = "@constant.c"})
vim.api.nvim_set_hl(0, '@lsp.type.type.c', {link = "@constant.c"})
vim.api.nvim_set_hl(0, '@lsp.type.enum.c', {link = "@constant.c"})
vim.api.nvim_set_hl(0, '@lsp.type.class.c', {link = "@constant.c"})
vim.api.nvim_set_hl(0, '@type.c', {link = "@constant.c"})
-- vim.api.nvim_set_hl(0, '@lsp.type.macro.c', {link = "@constant.c"})

vim.api.nvim_set_hl(0, "@variable.parameter", {fg = "#ffb66e"})
