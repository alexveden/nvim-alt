return {
  {
    'quarto-dev/quarto-nvim',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require('quarto').setup {
        -- Configuration here, or leave empty to use defaults
        ft = { 'quarto' },
        dev = false,
        opts = {
          lspFeatures = {
            languages = { 'python', 'bash', 'lua', 'html', 'dot' },
          },
          codeRunner = {
            enabled = true,
            default_method = 'molten', -- see jupyter.lua plugin for init
          },
          keymap = {
            -- set whole section or individual keys to `false` to disable
            hover = '<C-q>',
            definition = 'gd',
            type_definition = 'gD',
            rename = '<leader>lr',
            format = '<leader>lf',
            references = 'gr',
            document_symbols = '<C-d>',
          },
        },
      }
    end,
  },
  { -- paste an image from the clipboard or drag-and-drop
    'HakonHarnes/img-clip.nvim',
    event = 'BufEnter',
    ft = { 'markdown', 'quarto', 'latex' },
    opts = {
      default = {
        dir_path = 'img',
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = '![$CURSOR]($FILE_PATH)',
          drag_and_drop = {
            download_images = false,
          },
        },
        quarto = {
          url_encode_path = true,
          template = '![$CURSOR]($FILE_PATH)',
          drag_and_drop = {
            download_images = false,
          },
        },
      },
    },
    config = function(_, opts)
      require('img-clip').setup(opts)
      vim.keymap.set('n', '<leader>ii', ':PasteImage<cr>', { desc = 'insert [i]mage from clipboard' })
    end,
  },
}
