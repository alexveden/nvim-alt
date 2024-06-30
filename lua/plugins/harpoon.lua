return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    }

    -- Keymaps
    harpoon:extend {
      UI_CREATE = function(cx)
        vim.keymap.set('n', '<C-s>', function()
          harpoon.ui:select_menu_item { vsplit = true }
        end, { buffer = cx.bufnr })
      end,
    }
  end,
}
