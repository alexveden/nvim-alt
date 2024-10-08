local ls = require 'luasnip'
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require('luasnip.extras').lambda
local rep = require('luasnip.extras').rep
local p = require('luasnip.extras').partial
local m = require('luasnip.extras').match
local n = require('luasnip.extras').nonempty
local dl = require('luasnip.extras').dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local types = require 'luasnip.util.types'
local conds = require 'luasnip.extras.conditions'
local conds_expand = require 'luasnip.extras.conditions.expand'

return {
  s('заг1', t '# '),
  s('заг2', t '## '),
  s('заг3', t '### '),
  s('заг4', t '#### '),
  s('карт', fmt('![{}]({})', { i(1, 'alt text'), i(2, 'url') })),
  s('линк', fmt('[{}]({})', { i(1, 'text'), i(2, 'url') })),
  s('ссылка', fmt('[{}]({})', { i(1, 'text'), i(2, 'url') })),
  s('тодо', fmt('- [{}] {}', { i(1, ' '), i(2, 'ТОДО') })),
  s('таск', fmt('- [{}] {}', { i(1, ' '), i(2, 'ТОДО') })),
  s('важно', fmt('> [!IMPORTANT] {}\n> {}', { i(1, 'Важно'), i(2, 'что важно?') })),
  s('идея', fmt('> [!TIP] {}\n> {}', { i(1, 'Идея'), i(2, 'какая идея?') })),
  s('внимание', fmt('> [!WARNING] {}\n> {}', { i(1, 'Внимание'), i(2, 'что случилось?') })),
  s('цитата', fmt('> {}', { i(1, 'о чем') })),
  s('разделитель', t('---------')),
  s('дата', t(vim.fn.strftime("%Y-%m-%d %H:%M"))), 
}
