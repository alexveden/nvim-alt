-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
-- vim.opt.mouse = 'a'
vim.opt.mouse = ''

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Virtual edit (allowing goto past last char)
vim.opt.virtualedit = 'onemore'
-- Fix occasional reset of virtualedit, but some shitty plugin
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    vim.opt.virtualedit = 'onemore'
  end,
})

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeout = true
vim.opt.timeoutlen = 1000

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- word wrap off
vim.opt.wrap = false

-- spell on
vim.opt.spell = true
vim.opt.spelllang = 'en,ru'
vim.opt.spelloptions = 'camel,noplainbuffer'
vim.opt.spellcapcheck = ''

-- tabs / indents
vim.opt.tabstop = 4 -- Tab ident width
vim.opt.shiftwidth = 4 -- Indent width when >>
vim.opt.expandtab = true -- Convert tab to spaces
vim.opt.smarttab = true
vim.opt.copyindent = true
vim.opt.breakindent = true -- wrap indent to match  line start
vim.opt.preserveindent = true -- preserve indent structure as much as possible

-- cursor options
vim.opt.guicursor = 'i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150'

-- folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevelstart = 99
vim.opt.colorcolumn = '89'
vim.opt.foldopen:remove("search") -- NOTE: excludes results from folded from /? search

-- rip grep as grep program (with source code grepping)
vim.opt.grepprg = 'rg --vimgrep'

local function escape(str)
  -- You need to escape these characters to work correctly
  local escape_chars = [[;,."|\]] .. '[]'
  return vim.fn.escape(str, escape_chars)
end

-- Recommended to use lua template string
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
  -- | `to` should be first     | `from` should be second
  escape(ru_shift)
    .. ';'
    .. escape(en_shift),
  escape(ru) .. ';' .. escape(en),
}, ',')

-- vim: ts=2 sts=2 sw=2 et
