-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  -- 'nvim-neo-tree/neo-tree.nvim',
  dir = '/home/ubertrader/code/neo-tree.nvim/',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {},
  config = function()
    local neotree = require 'neo-tree'

    local scroll_fn = function(winid, direction)
      local input = direction > 0 and [[]] or [[]]
      local count = math.abs(direction)

      vim.api.nvim_win_call(winid, function()
        vim.cmd([[normal! ]] .. count .. input)
      end)
    end

    local preview_move_dn = function(state)
      local Preview = require 'neo-tree.sources.common.preview'

      local node = state.tree:get_node()
      if node.type ~= 'file' then
        return
      end

      if not Preview:is_active() then
        return
      end

      Preview.focus()
      local win_id = vim.api.nvim_get_current_win()
      scroll_fn(win_id, 20)
      vim.fn.win_gotoid(state.winid)
    end

    local preview_or_expand = function(state)
      local common_commands = require 'neo-tree.sources.common.commands'
      local commands = require 'neo-tree.sources.filesystem.commands'
      local Preview = require 'neo-tree.sources.common.preview'

      local node = state.tree:get_node()
      if node.type == 'file' then
        if not Preview:is_active() then
          common_commands.toggle_preview(state)
        end
        return
      else
        commands.toggle_node(state)
      end
    end

    local collapse_close_preview = function(state)
      local commands = require 'neo-tree.sources.common.commands'
      local Preview = require 'neo-tree.sources.common.preview'

      Preview:hide()

      commands.close_node(state, nil)
    end

    local harpoon_mapping = function(state)
      local isok, harpoon = pcall(require, 'harpoon')
      if not isok then
        print 'No harpoon installed, skipping'
        return
      end

      -- harpoon:list():clear()

      local node = state.tree:get_node()
      if node.type ~= 'file' then
        print 'Hanpooning: use only for files!'
        return
      end
      local Path = require 'plenary.path'
      local norm_path = Path:new(node.path):make_relative(vim.loop.cwd())

      -- print(vim.inspect(node))
      --
      local item = {
        value = norm_path,
        context = {
          row = 1,
          col = 1,
        },
      }
      harpoon:list():add(item)

      print('Harpooned: ' .. norm_path)
      -- for key, value in pairs(args) do
      --   print(key)
      -- end
    end

    local opts = {
      default_component_configs = {
        indent = { padding = 0 },
        icon = {
          folder_closed = '',
          folder_open = '',
          folder_empty = '',
          folder_empty_open = '',
          default = '󰈙',
        },
        modified = { symbol = '' },
        git_status = {
          symbols = {
            added = '',
            deleted = '',
            modified = '',
            renamed = '➜',
            untracked = '★',
            ignored = '◌',
            unstaged = '✗',
            staged = '✓',
            conflict = '',
          },
        },
        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        last_modified = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
      },

      filesystem = {
        window = {
          mappings = {
            -- ['\\'] = 'close_window',
            ['<Right>'] = { command = preview_or_expand, desc = 'expand folder or preview', config= { use_float = true, use_image_nvim = false }},
            ['<Left>'] = { command = collapse_close_preview, desc = 'close' },
            -- ['<Right>'] = { 'preview', config = { use_float = true, use_image_nvim = false } },
            ['z'] = 'expand_all_nodes',
            ['c'] = 'close_node',
            ['C'] = 'copy',
            ['Z'] = 'close_all_nodes',
            ['<C-h>'] = { command = harpoon_mapping, desc = '[h]arpoon add' },
            ['h'] = { command = harpoon_mapping, desc = '[h]arpoon add' },
            ['<C-d>'] = 'noop',
            ['<C-u>'] = 'noop',
            ['<C-PageUp>'] = { 'scroll_preview', config = { direction = 10 } },
            ['<C-PageDown>'] = { 'scroll_preview', config = { direction = -10 } },
          },
        },
      },
    }

    neotree.setup(opts)
  end,
}
