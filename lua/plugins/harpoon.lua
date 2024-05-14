return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,

      }
    })
    -- REQUIRED


  end,
}
