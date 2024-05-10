return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'onsails/lspkind.nvim',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp',
  },
  event = 'InsertEnter',
  opts = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'

    -- Add autopairs event
    cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done { tex = false })

    local border_opts = {
      border = 'rounded',
      winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
    }

    local lspkind_format = {
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      -- can also be a function to dynamically calculate max width such as
      -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        return vim_item
      end,

      symbol_map = {
        Text = '󰉿',
        Method = '󰆧',
        Function = '󰊕',
        Constructor = '',
        Field = '󰜢',
        Variable = '󰀫',
        Class = '󰠱',
        Interface = '',
        Module = '',
        Property = '󰜢',
        Unit = '󰑭',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '',
        Color = '󰏘',
        File = '󰈙',
        Reference = '󰈇',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰏿',
        Struct = '󰙅',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '',
      },
    }

    return {
      enabled = function()
        if vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt' then
          return false
        end
        return true
      end,
      preselect = cmp.PreselectMode.None,
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = lspkind.cmp_format(lspkind_format),
      },
      snippet = {
        expand = function(args)
          -- This for expanding functions from LSP
          luasnip.lsp_expand(args.body)
          -- prevent snippet like behavior
          luasnip.unlink_current()
          local prev_col = vim.fn.col '.' - 1
          local prev_char = vim.fn.getline('.'):sub(prev_col, prev_col)
          if prev_char == ')' then
            -- we are in the function end, goto inside parenthesis
            vim.cmd 'normal! h'
          end
        end,
      },
      duplicates = {
        nvim_lsp = 1,
        luasnip = 1,
        cmp_tabnine = 1,
        buffer = 1,
        path = 1,
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      window = {
        completion = cmp.config.window.bordered(border_opts),
        documentation = cmp.config.window.bordered(border_opts),
      },
      mapping = {
        ['<C-PageUp>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
        ['<C-PageDown>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),

        ['<CR>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if cmp.get_active_entry() then
              cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
            end
          elseif luasnip.in_snippet() or luasnip.choice_active() then
            luasnip.unlink_current()
            -- vim.api.nvim_feedkeys '<esc><cr>'
          else
            fallback()
          end
        end, { 'i', 'n' }),

        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            local entry = cmp.get_selected_entry()
            if not entry then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
            end
            cmp.confirm()
          else
            fallback()
          end
        end, { 'i' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if not cmp.visible() then
            fallback()
          end
        end, { 'i' }),

        ['<Down>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 'c' }),

        ['<Up>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 'c' }),
      },

      sorting = {
        priority_weight = 1.0,
        comparators = {
          -- compare.score_offset, -- not good at all
          cmp.config.compare.recently_used,
          cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
          cmp.config.compare.locality,
          cmp.config.compare.offset,
          cmp.config.compare.order,
          -- cmp.config.compare.scopes, -- what?
          -- cmp.config.compare.sort_text,
          -- cmp.config.compare.exact,
          -- cmp.config.compare.kind,
          -- cmp.config.compare.length, -- useless
        },
      },

      sources = cmp.config.sources {
        { name = 'otter' },
        { name = 'luasnip_choice', priority = 1500 }, --- FIX: not working!
        { name = 'luasnip', priority = 1000 },
        { name = 'nvim_lsp', priority = 999 },
        { name = 'buffer', priority = 500, option = {
          keyword_pattern = [[\k\+]],
        } },
        { name = 'path', priority = 250 },
      },
    }
  end,
}
