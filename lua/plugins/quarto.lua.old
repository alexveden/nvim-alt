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
}
