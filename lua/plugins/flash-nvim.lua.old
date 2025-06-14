return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  config = function()
    local flash = require 'flash'
    local langmapper = require 'langmapper'

    for _, mode in pairs({"n", "x", "o"}) do
      langmapper.original_set_keymap(mode, 's', '', {
        nowait = true,
        desc = 'Flash',
        callback = function()
          flash.jump()
        end,
      })
      langmapper.original_set_keymap(mode, 'ы', '', {
        nowait = true,
        desc = 'Flash',
        callback = function()
          flash.jump({labels="олджавыфгнрткепимйцуячсшщзьбюАВЫФОЛДЖЙЦУКЕНГШЩЗ"})
        end,
      })
    end

    ---@type Flash.Config
    local opts = { modes = { char = { enabled = false } } }

    flash.setup(opts)
  end,
  -- stylua: ignore
  keys = {
    -- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    -- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    -- { "ы", mode = { "n", "x", "o" }, function() require("flash").jump({labels="олджавыфйцукепсмнрт"}) end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
