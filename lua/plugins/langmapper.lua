return {
  'Wansmer/langmapper.nvim',
  lazy = false,
  priority = 2, -- High priority is needed if you will use `autoremap()`
  config = function()
    require('langmapper').setup {}
    require('langmapper').hack_get_keymap()
  end,
}
