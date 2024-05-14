-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {},
  opts = {
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
          ['z'] = 'expand_all_nodes',
          ['c'] = 'close_node',
          ['C'] = 'copy',
          ['Z'] = 'close_all_nodes',
        },
      },
    },
  },
}
