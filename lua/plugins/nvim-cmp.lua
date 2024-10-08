return {
  'hrsh7th/nvim-cmp',
  -- enabled = false,
  dependencies = {
    'L3MON4D3/LuaSnip',
    'onsails/lspkind.nvim',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp',
  },
  event = 'InsertEnter',
  config = function()
    local cmp = require 'cmp'
    -- local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'

    -- Add autopairs event
    cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done { tex = false })

    cmp.event:on('menu_closed', function()
      local langmapper = require 'langmapper'
      langmapper._hack_keymap()
      langmapper.hack_get_keymap()
    end)

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
      show_labelDetails = false, -- show labelDetails in menu. Disabled by default

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        -- Resetting menu to "", fixes oversized CMP window for clang
        -- This excludes signature data from the CMP window
        -- vim_item.menu = entry.source.name
        vim_item.menu = ''

        -- this prevents items duplication
        vim_item.dup = 0

        -- print(vim.inspect(vim_item))
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

    local cmp_sorter_custom_unknown = function(entry1, entry2)
      if entry1.completion_item.sortText and entry2.completion_item.sortText then
        print(vim.inspect(entry1.completion_item))
        print(vim.inspect(entry2.completion_item))

        local diff = vim.stricmp(entry1.completion_item.sortText, entry2.completion_item.sortText)
        if diff < 0 then
          return true
        elseif diff > 0 then
          return false
        end
      end
      return nil
    end

    local opts = {
      enabled = function()
        if vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt' then
          return false
        end

        local langmapper = require 'langmapper'
        langmapper.put_back_keymap()

        return true
      end,
      preselect = cmp.PreselectMode.None,
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = lspkind.cmp_format(lspkind_format),
      },
      -- snippet = {
      --   expand = function(args)
      --     print(vim.inspect(args))
      --     -- 2024-06-03 fixing CEX macro expansion buf i.e. for$array
      --     local cex_macro_regex = '(%w+)%$(%w+)(%(.*%))'
      --     if string.match(args.body, cex_macro_regex) then
      --       -- replace $ dollar by $$, this makes macro expand well
      --       args.body, _ = string.gsub(args.body, cex_macro_regex, '%1$$%2%3')
      --     end
      --     -- This for expanding functions from LSP
      --     luasnip.lsp_expand(args.body)
      --     -- prevent snippet like behavior
      --     luasnip.unlink_current()
      --     local prev_col = vim.fn.col '.' - 1
      --     local prev_char = vim.fn.getline('.'):sub(prev_col, prev_col)
      --     if prev_char == ')' then
      --       -- we are in the function end, goto inside parenthesis
      --       vim.cmd 'normal! h'
      --     end
      --     --
      --     --
      --   end,
      -- },
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
            -- cmp.close()
            if cmp.get_active_entry() then
              cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
            else
              fallback()
            end
          else
            fallback()
          end
        end, { 'i', 'n' }),
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
          cmp.config.compare.locality,
          cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
          -- cmp_sorter_custom_unknown,
          cmp.config.compare.sort_text,
          -- cmp.config.compare.exact,
          -- cmp.config.compare.scopes,
          -- cmp.config.compare.kind,
          -- cmp.config.compare.scopes, -- what?
          -- cmp.config.compare.offset,
          -- cmp.config.compare.order,
          -- cmp.config.compare.length, -- useless
        },
      },

      -- NOTE: element order means priority in CMP window
      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        -- { name = 'luasnip'},
        -- { name = 'luasnip_choice'}, --- FIX: not working!
        -- { name = 'otter' },
        { name = 'buffer', option = {
          keyword_pattern = [[\k\+]],
        } },
        { name = 'path' },
      },

    }

    cmp.setup(opts)

    cmp.setup.filetype({ 'markdown', 'help' }, {
      matching = {
        disallow_partial_fuzzy_matching=true,
        disallow_symbol_nonprefix_matching=false,
        disallow_partial_matching=true,
        disallow_fuzzy_matching=true,
        disallow_fullfuzzy_matching=false,
        disallow_prefix_unmatching=false,
      },
      sources = {
        { name = 'path' },
        { name = 'luasnip',  keyword_pattern = [[\k\+]]},
      },
    })
  end,
}
