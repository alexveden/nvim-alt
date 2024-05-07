-- Python specific options
-- use vim.bo - for local options
-- use vim.api.nvim_buf_set_keymap()

-- Include common settings for code
vim.cmd 'runtime! ftplugin/common_code.lua'

-- set specific flag for python/jupytext notebook
-- check if any '# %%' in file
--
local is_jupyter = false
local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
for _, line in ipairs(all_lines) do
  if line:match '^# %%%%' then
    is_jupyter = true
    break
  end
end

-- This might be used by other plugins for conditional actions
vim.api.nvim_buf_set_var(0, 'python_is_jupyter', is_jupyter)

if is_jupyter then
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-CR>', "<cmd>lua require('notebook-navigator').run_and_move()<cr>", { desc = '[J]upyter run to next' })
  vim.api.nvim_buf_set_keymap(0, 'n', '<S-CR>', "<cmd>lua require('notebook-navigator').run_cell()<cr>", { desc = '[J]upyter run in-place' })
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ja', "<cmd>lua require('notebook-navigator').run_all_cells()<cr>", { desc = '[J]upyter [a]ll below' })
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jo', ':noautocmd MoltenEnterOutput<CR>', { desc = '[J]upyter goto [o]utput', silent = true })
  vim.api.nvim_buf_set_keymap(0, 'v', '<leader>jv', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = '[J]upyter exec [v]isual', silent = true })
else
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jf', ':lua require("text_objects").f_string_prepend()<CR>', { desc = 'add f- prefix for string' })
end
