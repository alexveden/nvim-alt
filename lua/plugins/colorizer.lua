-- vim-pencil is soft text wrapper tool
return {
  {
    'norcalli/nvim-colorizer.lua',
    lazy = false,
    enabled = true,
    config = function()
      -- Attaches to every FileType mode
      require('colorizer').setup()
    end,
  },
}
