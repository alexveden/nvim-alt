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

local snutils = require 'snippets.snutils'
local h = snutils.hint

return {
  s('jc', {
    t {"", '# %%', ""},
    i(0, '', h 'Jupyter code cell'),
  }),
  s('jm', {
    t {"", '# %% [markdown]', ""},
    t {'"""', ""},
    i(0, '', h 'Jupyter markdown cell'),
    t {"", '"""', ""},
  }),
  s('jquarto', {
    t {"", '# %% [markdown]'},
    t {"", "# ---"},
    t {"", "# title: "}, i(1, '', h 'Quarto Document title'),
    t {"", "# autor: Alex Veden <i@alexveden.com>"},
    t({"", "# date: ".. os.date('%Y-%m-%d %H:%M:%S')}),
    t({"", "# ---"}),
    t({"", "#", "", ""}),
    i(0, '', h 'Quarto Document Header'),

  }),
}
