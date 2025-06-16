-- [[ Basic Keymaps ]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Set 'p' to paste, without replacing default register by selection
-- vim.cmd 'xnoremap p P'
vim.cmd [[xnoremap p "_dP]]

-- yank and end cursor at the last position
vim.api.nvim_set_keymap('x', 'y', 'ygv<Esc>', { noremap = true, silent = true })

-------------------------------------------------------------------------------
--
-- Navigation keys
--
-------------------------------------------------------------------------------

-- Split/TMUX navigation
vim.keymap.set('n', '<S-Up>', ':<C-U>TmuxNavigateUp<cr>', { desc = 'Split move up', silent = true })
vim.keymap.set('n', '<S-Down>', ':<C-U>TmuxNavigateDown<cr>', { desc = 'Split move down', silent = true })
vim.keymap.set('n', '<S-Left>', ':<C-U>TmuxNavigateLeft<cr>', { desc = 'Split move left', silent = true })
vim.keymap.set('n', '<S-Right>', ':<C-U>TmuxNavigateRight<cr>', { desc = 'Split move right', silent = true })

-- Text navigation
vim.keymap.set({ 'n', 'v' }, '<Home>', '^', { desc = 'Jump to first non-blank char', silent = true })
vim.keymap.set({ 'n', 'v' }, '<End>', 'g_l', { desc = 'Jump to last non-blank char', silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-u>', '<C-u>zz', { desc = 'Jump half-page up', silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-d>', '<C-d>zz', { desc = 'Jump half-page down', silent = true })
vim.keymap.set({ 'n', 'v' }, '<PageUp>', '8k', { desc = 'Jump 10 up', silent = true })
vim.keymap.set({ 'n', 'v' }, '<PageDown>', '8j', { desc = 'Jump 10 down', silent = true })

vim.keymap.set({ 'i' }, '<Home>', '<C-o>^', { desc = 'Jump to first non-blank char', silent = true })
vim.keymap.set({ 'i' }, '<End>', '<C-o>g_<C-o>l', { desc = 'Jump to last non-blank char', silent = true })
vim.keymap.set({ 'i' }, '<PageUp>', '<C-o>8k', { desc = 'Jump 10 up', silent = true })
vim.keymap.set({ 'i' }, '<PageDown>', '<C-o>8j', { desc = 'Jump 10 down', silent = true })

-- Control-Backspace
vim.keymap.set({ 'i' }, '<C-H>', '<C-W>', { desc = 'Delete whole ' })
vim.keymap.set('n', 'G', 'Gzz', { desc = 'End and center screen' })

-- Mouse scroll fix ??
vim.keymap.set({ 'n', 'v', 'i' }, '<ScrollWheelUp>', '<C-Y>')
vim.keymap.set({ 'n', 'v', 'i' }, '<ScrollWheelDown>', '<C-E>')

-- Disable some defaults
vim.keymap.set('n', '<S-Home>', '<Nop>')
vim.keymap.set('n', '<S-End>', '<Nop>')
-- vim.keymap.set({ 'n', 'v' }, '<C-Right>', '<nop>')
-- vim.keymap.set({ 'n', 'v' }, '<C-Left>', '<nop>')
vim.keymap.set({ 'n', 'v' }, '<S-h>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<S-j>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<S-k>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<S-l>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, 'h', '<Nop>')
vim.keymap.set({ 'n', 'v' }, 'j', '<Nop>')
vim.keymap.set({ 'n', 'v' }, 'k', '<Nop>')
vim.keymap.set({ 'n', 'v' }, 'l', '<Nop>')
-- vim.keymap.set({ 'n', 'v' }, '<C-u>', '<Nop>')
-- vim.keymap.set({ 'n', 'v' }, '<C-o>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<C-y>', '<Nop>')
--vim.keymap.set({ 'n', 'v' }, '<C-h>', '<Nop>')
-- vim.keymap.set({ 'n', 'v', 'i' }, '<PageUp>', '<Nop>')
-- vim.keymap.set({ 'n', 'v', 'i' }, '<PageDown>', '<Nop>')
-------------------------------------------------------------------------------
--
-- Text/Code editing actions keys
--
-------------------------------------------------------------------------------

-- Code jumps
vim.keymap.set('n', '<C-Home>', '<tab>', { desc = 'Jump previous', silent = true })
vim.keymap.set('n', '<C-End>', '<C-o>', { desc = 'Jump previous', silent = true })

-- Tab indents
-- NOTE: Tab binding must be after <Jump-previous
vim.keymap.set('n', '<Tab>', '>>', { desc = 'Indent right' })
vim.keymap.set('n', '<S-Tab>', '<<', { desc = 'Indent left ' })
vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Indent right' })
vim.keymap.set('v', '<S-Tab>', '<gv', { desc = 'Indent left ' })

-- Move lines of code
vim.keymap.set('n', '<C-Up>', '<cmd>m .-2<CR>==', { desc = 'Move line Up', silent = true })
vim.keymap.set('n', '<C-Down>', '<cmd>m .+1<CR>==', { desc = 'Move line Down', silent = true })
vim.keymap.set('v', '<C-Up>', ":m '<-2<CR><CR>gv=gv", { desc = 'Move selection Up', silent = true })
vim.keymap.set('v', '<C-Down>', ":m '>+1<CR><CR>gv=gv", { desc = 'Move selection Down', silent = true })
vim.keymap.set('n', '<C-Left>', 'zc', { desc = 'Close fold', silent = true })
vim.keymap.set('n', '<C-Right>', 'zo', { desc = 'Open fold', silent = true })

-- Using Ctrl+/ (similar to many IDEs)
vim.keymap.set('n', '<C-_>', 'gcc', { remap = true })
vim.keymap.set('x', '<C-_>', 'gc', { remap = true })

-------------------------------------------------------------------------------
--
-- Core Interface keys
--
-------------------------------------------------------------------------------
-- vim.keymap.set({ 'n', 'v' }, '<leader>s', '<Esc>:w!<cr>', { desc = 'Save file' })
vim.keymap.set({ 'n', 'v' }, '<leader>w', '<Esc>:w!<cr>', { desc = 'Write file' })
vim.keymap.set({ 'n', 'v' }, '<leader>s', "<Esc>:lua error('use :w')<cr>", { desc = 'Save file (use <leader>w)' })

vim.keymap.set({ 'n' }, '<leader>z', '<cmd>ZenMode<cr>', { desc = '[Z]enMode' })

-- Leader main menu
-- vim.keymap.set({ 'n' }, '<leader>c', '<cmd>bd<cr>', { desc = '[C]lose current buffer/window' })
vim.keymap.set({ 'n' }, '<leader>q', '<cmd>bd<cr>', { desc = '[Q]uit current buffer/window' })
vim.keymap.set({ 'n' }, '<leader>c', "<Esc>:lua error('use <C-W>q')<cr>", { desc = '[q]uit window <leader>q' })

-- Buffer related
vim.keymap.set({ 'n' }, '<leader>b|', '<cmd>vsplit<cr>', { desc = 'Vertical split' })
vim.keymap.set({ 'n' }, '<leader>b-', '<cmd>split<cr>', { desc = 'Vertical split' })
vim.keymap.set({ 'n' }, '<leader>bo', '<cmd>%bd|e#|bd#<cr><cr>', { desc = 'Buffer close [o]ther' })
vim.keymap.set({ 'n' }, '<leader>bn', '<cmd>enew<cr>', { desc = '[B]uffer [n]ew' })
vim.keymap.set({ 'n' }, '<leader>bu', '<cmd>Telescope undo<cr>', { desc = '[B]uffer [u]ndo tree' })
vim.keymap.set({ 'n' }, '<leader>bl', '<cmd>Telescope buffers<cr>', { desc = '[B]uffer [l]ist' })
vim.keymap.set({ 'n' }, '<leader>bd', '<cmd>bd<cr>', { desc = '[B]uffer [d]elete / close' })

-- Just in case keys
vim.keymap.set({ 'n' }, '<leader>jr', ':.,$s@\\V<C-R><C-W>@<C-R><C-W>@gc<Left><Left><Left>', { desc = 'Replace word under cursor' })
vim.keymap.set({ 'v' }, '<leader>jr', 'y:.,$s@\\V<C-R>"@<C-R>"@gc<Left><Left><Left>', { desc = 'Replace selection' })

-- Interface quick toggle
vim.keymap.set({ 'n' }, '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = '[T]oggle [w]rap' })

vim.keymap.set({ 'n' }, '<leader>ts', function()
  vim.wo.spell = not vim.wo.spell
end, { desc = '[T]oggle [s]pellcheck' })

vim.keymap.set({ 'n' }, '<leader>td', function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
  vim.wo.spell = not vim.wo.spell
end, { desc = '[T]oggle [d]iagnostics' })

-- NOTE: Telescope bindings are in plugins/telescope.lua
-- NOTE: Snippet/CMP bindings in plugins/blink-cmp.lua
-- NOTE: Git bindings are in plugins/gitsigns.lua
-- NOTE: Quick fix window in lua/plugins/quickfix.lua
