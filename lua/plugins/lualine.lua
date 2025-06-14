-- A blazing fast and easy to configure Neovim statusline written in Lua.
return {
  'nvim-lualine/lualine.nvim',
  -- dependencies = { 'nvim-tree/nvim-web-devicons' },
  dependencies = { 'echasnovski/mini.icons', opts = {} },
  config = function()
    local ftype_base = require 'lualine.components.filetype'

    local ftype = function()
      local status, is_jupyter = pcall(vim.api.nvim_buf_get_var, 0, 'python_is_jupyter')
      if status and is_jupyter then
        return vim.bo.filetype .. ' (jupyter)'
      else
        return ftype_base.update_status()
      end
    end
    local has_nonsaved_buf = function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(buf, 'modified') then
          return ''
        end
      end
      return ''
    end
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },

        disabled_filetypes = {
          statusline = { 'neo-tree' },
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          { has_nonsaved_buf, color = { fg = '#ffaa88', bg = 'black' }, separator = { left = '', right = '' } },
          {
            'filename',
            file_status = true,    -- Displays file status (readonly status, modified status)
            newfile_status = true, -- Display new file status (new file means no write after created)
            path = 1,              -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory

            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = '[+]',      -- Text to show when the file is modified.
              readonly = '[RO]',     -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]',     -- Text to show for newly created file before first write
            },
          },
        },
        lualine_x = { 'encoding', 'fileformat', ftype },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        -- lualine_c = {},
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { has_nonsaved_buf, color = { fg = '#ffaa88', bg = 'black' }, separator = { left = '', right = '' } },
          {
            'filename',
            file_status = true,     -- Displays file status (readonly status, modified status)
            newfile_status = false, -- Display new file status (new file means no write after created)
            path = 1,               -- 0: Just the filename
            -- 1: Relative path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory
            -- 2: Absolute path

            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = '[+]',      -- Text to show when the file is modified.
              readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]',     -- Text to show for newly created file before first write
            },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      winbar = {},
      inactive_winbar = {},

      extensions = {},
    }
  end,
}
