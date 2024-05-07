return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { 'magick' },
    },
  },
  {
    '3rd/image.nvim',
    dependencies = { 'luarocks.nvim' },
    config = function()
      require('image').setup {
        backend = 'ueberzug',
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
          },
          neorg = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { 'norg' },
          },
          html = {
            enabled = false,
          },
          css = {
            enabled = false,
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
        editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp' }, -- render image files as images when opened
      }
    end,
  },
  {
    'benlubas/molten-nvim',
    enabled = true,
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      -- vim.g.molten_image_provider = 'none'
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_virt_text_output = true
      vim.g.molten_auto_open_output = true
      vim.g.molten_output_win_hide_on_leave = false
    end,
    keys = {
      { '<leader>mi', ':MoltenInit<cr>', desc = '[m]olten [i]nit' },
      {
        '<leader>mv',
        ':<C-u>MoltenEvaluateVisual<cr>',
        mode = 'v',
        desc = 'molten eval visual',
      },
      { '<leader>mr', ':MoltenReevaluateCell<cr>', desc = 'molten re-eval cell' },
      { '<leader>ml', ':MoltenEvaluateLine<cr>', desc = 'molten re-eval line' },
    },
  },
  { -- directly open ipynb files as quarto docuements
    -- and convert back behind the scenes
    -- needs:
    -- pip install jupytext
    'GCBallesteros/jupytext.nvim',
    opts = {
      custom_language_formatting = {
        python = {
          extension = 'py',
          style = 'percent',
          -- force_ft = 'python', -- you can set whatever filetype you want here
        },
      },
    },
  },

  {
    'GCBallesteros/NotebookNavigator.nvim',
    keys = {
      { '<leader>X', "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
      { '<leader>x', "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
    },
    dependencies = {
      'echasnovski/mini.comment',
      -- 'hkupty/iron.nvim', -- repl provider
      -- 'akinsho/toggleterm.nvim', -- alternative repl provider
      'benlubas/molten-nvim', -- alternative repl provider
      -- 'anuvyklack/hydra.nvim',
    },
    event = 'VeryLazy',
    config = function()
      local nn = require 'notebook-navigator'
      nn.setup {
        repl_provider = 'molten',
      }
    end,
  },
}
