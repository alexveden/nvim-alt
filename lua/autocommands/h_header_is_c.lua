-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
vim.api.nvim_create_autocmd({"BufEnter"}, {
	desc = 'Set all .h headers as c by default',
	pattern = "*.h",
	callback = function()
	  vim.bo.filetype = "c"
	end,
})

-- always return empty
return {}
