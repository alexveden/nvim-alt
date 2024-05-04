-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-------------------------------------------------------------------------------
--
-- Navigation keys
--
-------------------------------------------------------------------------------

-- Tabs switching
vim.keymap.set('n', '<C-Right>', '<cmd>BufferNext<cr>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-Left>', '<cmd>BufferPrevious<cr>', { desc = 'Move focus to the right window' })

-- Split/TMUX navigation
vim.keymap.set('n', '<S-Up>', ':<C-U>TmuxNavigateUp<cr>', { desc = 'Split move up' })
vim.keymap.set('n', '<S-Down>', ':<C-U>TmuxNavigateDown<cr>', { desc = 'Split move down' })
vim.keymap.set('n', '<S-Left>', ':<C-U>TmuxNavigateLeft<cr>', { desc = 'Split move left' })
vim.keymap.set('n', '<S-Right>', ':<C-U>TmuxNavigateRight<cr>', { desc = 'Split move right' })

-- Text navigation
vim.keymap.set({ 'n', 'v' }, '<Home>', '^', { desc = 'Jump to first non-blank char' })
vim.keymap.set({ 'n', 'v' }, '<End>', 'g_', { desc = 'Jump to last non-blank char' })
vim.keymap.set({ 'n', 'v' }, '<PageUp>', '10k', { desc = 'Jump 5 up' })
vim.keymap.set({ 'n', 'v' }, '<PageDown>', '10j', { desc = 'Jump 5 down' })
vim.keymap.set({ 'i' }, '<Home>', '<C-o>^', { desc = 'Jump to first non-blank char' })
vim.keymap.set({ 'i' }, '<End>', '<C-o>g_', { desc = 'Jump to last non-blank char' })
vim.keymap.set({ 'i' }, '<PageUp>', '<C-o>10k', { desc = 'Jump 5 up' })
vim.keymap.set({ 'i' }, '<PageDown>', '<C-o>10j', { desc = 'Jump 5 down' })
vim.keymap.set('n', 'G', 'Gzz', { desc = 'End and center screen' })

-- Mouse scroll fix ??
vim.keymap.set({ 'n', 'v', 'i' }, '<ScrollWheelUp>', '<C-Y>')
vim.keymap.set({ 'n', 'v', 'i' }, '<ScrollWheelDown>', '<C-E>')

-- Disable some defaults
vim.keymap.set('n', '<S-Home>', '<Nop>')
vim.keymap.set('n', '<S-End>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<C-h>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<C-j>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<C-k>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<C-l>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<S-h>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<S-j>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<S-k>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<S-l>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<C-u>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<C-o>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<C-h>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<C-y>', '<Nop>')

-------------------------------------------------------------------------------
--
-- Text/Code editing actions keys
--
-------------------------------------------------------------------------------

-- Folding
vim.keymap.set('n', 'za', 'zazz', { desc = 'Fold toggle + center' })
vim.keymap.set('n', 'zc', 'zczz', { desc = 'Fold close + center' })
vim.keymap.set('n', 'zm', 'zmzz', { desc = 'Fold open + center' })
vim.keymap.set('n', 'zz', 'zazz', { desc = 'Fold open + center' })
vim.keymap.set('n', 'z`', '<cmd>set foldlevel=0<CR>', { desc = 'foldlevel=0' })
vim.keymap.set('n', 'z1', '<cmd>set foldlevel=1<CR>', { desc = 'foldlevel=1' })
vim.keymap.set('n', 'z2', '<cmd>set foldlevel=2<CR>', { desc = 'foldlevel=2' })
vim.keymap.set('n', 'z3', '<cmd>set foldlevel=3<CR>', { desc = 'foldlevel=3' })
vim.keymap.set('n', '<C-PageUp>', 'zk', { desc = 'Jump next fold above' })
vim.keymap.set('n', '<C-PageDn>', 'zj', { desc = 'Jump next fold below' })

-- Code jumps
vim.keymap.set('n', '<C-Home>', '<tab>', { desc = 'Jump previous' })
vim.keymap.set('n', '<C-End>', '<C-o>', { desc = 'Jump previous' })

-- Tab indents
-- NOTE: Tab binding must be after <Jump-previous
vim.keymap.set('n', '<Tab>', '>>', { desc = 'Indent right' })
vim.keymap.set('n', '<S-Tab>', '<<', { desc = 'Indent left ' })
vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Indent right' })
vim.keymap.set('v', '<S-Tab>', '<gv', { desc = 'Indent left ' })

-- Move lines of code
vim.keymap.set('n', '<C-Up>', '<cmd>m .-2<CR>==', { desc = 'Move line Up' })
vim.keymap.set('n', '<C-Down>', '<cmd>m .+1<CR>==', { desc = 'Move line Down' })
vim.keymap.set('v', '<C-Up>', ":m '<-2<CR><CR>gv=gv", { desc = 'Move selection Up' })
vim.keymap.set('v', '<C-Down>', ":m '>+1<CR><CR>gv=gv", { desc = 'Move selection Down' })

-------------------------------------------------------------------------------
--
-- Interface keys
--
-------------------------------------------------------------------------------
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<Esc>:w!<cr>', { desc = 'Save file' })
vim.keymap.set({ 'n', 'v' }, '<leader>s', '<Esc>:w!<cr>', { desc = 'Save file' })
vim.keymap.set({ 'n' }, '<leader>c', '<cmd>BufferClose<cr>', { desc = 'Close current buffer' })

-- Leader main menu
vim.keymap.set({ 'n', 'i', 'v' }, '<leader>q', '<Esc>:q<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>o', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Tree' })
vim.keymap.set({ 'n' }, '<leader>n', '<cmd>enew<cr>', { desc = 'New file' })
vim.keymap.set({ 'n' }, '<leader>|', '<cmd>vsplit<cr>', { desc = 'Vertical split' })
vim.keymap.set({ 'n' }, '<leader>-', '<cmd>split<cr>', { desc = 'Horizontal split' })

-- Buffer related
vim.keymap.set({ 'n' }, '<leader>b|', '<cmd>vsplit<cr>', { desc = 'Vertical split' })
vim.keymap.set({ 'n' }, '<leader>b-', '<cmd>split<cr>', { desc = 'Vertical split' })
vim.keymap.set({ 'n' }, '<leader>bo', '<cmd>%bd|e#|bd#<cr><cr>', { desc = 'Close other tabs' })
vim.keymap.set({ 'n' }, '<leader>bc', '<cmd>BufferClose<cr>', { desc = 'Close other tabs' })

-- NOTE: Telescope bindings are in plugins/telescope.lua
-- 
