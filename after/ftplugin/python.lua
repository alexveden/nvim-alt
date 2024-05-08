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

--
-- Jupyter QtConsole launch and attach
--
local delayed_attach = function()
  -- kernel-qtconsole.json - has to be set in  ~/.jupyter/jupyter_qtconsole_config.py
  vim.cmd 'JupyterAttach kernel-qtconsole.json'
end

Run_qtconsole_and_attach = function()
  local vim_init_path = os.getenv 'MYVIMRC'
  local config_dir = vim.fn.fnamemodify(vim_init_path, ':p:h')

  vim.cmd(':silent !python ' .. config_dir .. '/scripts/run_qtconsole.py')
  -- vim.cmd('!python ' .. config_dir .. '/scripts/run_qtconsole.py')

  -- Delay 2000ms and 0 means "do not repeat"
  local timer = vim.loop.new_timer()
  timer:start(1000, 0, vim.schedule_wrap(delayed_attach))
end

--JupyterCellNext - fixes flaws in last "# %%" tag of a file
JupyterSelectCell = function(is_code_cell, is_around)
  -- NOTE: [J ]J - are treesitter jupyter specific text objects
  --
  -- vim.cmd "m'" -- mark current position

  local line_text = vim.api.nvim_get_current_line()
  local line_index = vim.api.nvim_win_get_cursor(0)[1]
  local line_count = vim.api.nvim_buf_line_count(0)

  local move_type = 'j'
  if is_code_cell then
    move_type = 'J'
  end

  -- Jump next cell and back to reset the header
  vim.cmd('normal ]' .. move_type)

  local line_index2 = vim.api.nvim_win_get_cursor(0)[1]
  --
  if line_index == line_index2 then
    -- After jump we ended at the same position, handle last cell in document!
    if string.match(line_text, '^# %%%%') then
      if line_index == line_count then
        if is_around then
          vim.cmd 'normal V'
        end
        return
      else
      end
    else
      -- we at the last cell, but in the middle, jump to head
      vim.cmd('normal [' .. move_type)
    end

    if not is_around then
      vim.cmd 'normal j'
    end

    -- select all till the end of document
    vim.cmd 'normal VG'
  else
    -- We have cells below
    vim.cmd('normal [' .. move_type)

    if not is_around then
      vim.cmd 'normal j'
    end

    vim.cmd 'normal V'
    vim.cmd('normal ]' .. move_type)
    vim.cmd 'normal k'
  end
end

--
-- Key bindings
--
-- Universal Jupyter + Python keys
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jf', ':lua require("text_objects").f_string_prepend()<CR>', { desc = 'add f- prefix for string' })

if is_jupyter then
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ja', ':lua Run_qtconsole_and_attach()<CR>', { desc = '[J]upyter QtConsole Run & [A]ttach' })

  --
  -- Jupyter Text mode
  -- jupyter generic cell object
  vim.api.nvim_buf_set_keymap(0, 'x', 'aj', ':<c-u>lua JupyterSelectCell(false, true)<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, 'o', 'aj', ':<c-u>lua JupyterSelectCell(false, true)<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, 'x', 'ij', ':<c-u>lua JupyterSelectCell(false, false)<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, 'o', 'ij', ':<c-u>lua JupyterSelectCell(false, false)<cr>', { noremap = true, silent = true })

  -- jupyter code cell object
  vim.api.nvim_buf_set_keymap(0, 'x', 'aJ', ':<c-u>lua JupyterSelectCell(true, true)<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, 'o', 'aJ', ':<c-u>lua JupyterSelectCell(true, true)<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, 'x', 'iJ', ':<c-u>lua JupyterSelectCell(true, false)<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, 'o', 'iJ', ':<c-u>lua JupyterSelectCell(true, false)<cr>', { noremap = true, silent = true })

  -- Execute next command
  -- mark j at current cursor position
  -- select inner cell code
  -- send to JupyterExecute
  -- can be jumpable back
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-CR>', "m'viJ<c-o>:JupyterExecute<cr>]J", { desc = '[J]upyter run to next', silent = true })
  vim.api.nvim_buf_set_keymap(0, 'i', '<C-CR>', "<esc>m'viJ<c-o>:JupyterExecute<cr>]J", { desc = '[J]upyter run to next', silent = true })
  vim.api.nvim_buf_set_keymap(0, 'v', '<C-CR>', "m'V<c-o>:JupyterExecute<cr>g`'", { desc = '[J]upyter run to next', silent = true })

  -- Execute in place command comment
  -- mark j at current cursor position
  -- select inner cell code
  -- send to JupyterExecute
  -- jump back to the same position
  vim.api.nvim_buf_set_keymap(0, 'n', '<S-CR>', "m'viJ<c-o>:JupyterExecute<cr>g`'", { desc = '[J]upyter run in-place', silent = true })
  vim.api.nvim_buf_set_keymap(0, 'v', '<S-CR>', "m'V<c-o>:JupyterExecute<cr>g`'", { desc = '[J]upyter run in-place', silent = true })
  vim.api.nvim_buf_set_keymap(0, 'i', '<S-CR>', "<esc>m'viJ<c-o>:JupyterExecute<cr>g`'", { desc = '[J]upyter run in-place', silent = true })

  vim.api.nvim_buf_set_keymap(0, 'n', '<C-PageUp>', '[j', { desc = '' })
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-PageDown>', ']j', { desc = '' })
else
  --
  -- Python mode
  --
end
