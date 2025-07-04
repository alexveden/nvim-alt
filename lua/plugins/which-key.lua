-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      --
      -- Normal mode
      --
      require('which-key').add {
        { '<leader>l', name = '  [L]SP' },
        { '<leader>b', name = '󰈙  [B]uffers' },
        { '<leader>f', name = '  [F]ind' },
        { '<leader>g', name = '󰊢  [G]it' },
        { '<leader>t', name = '  [T]oggle' },
        { '<leader>j', name = '  [J]ust in case' },
        { '<leader>q', name = '  [Q]uit Current Window' },
        { '<leader>r', name = '  [R]EPL Console' },
      }
      --
      --Visual mode
      --
      require('which-key').add {
        mode = { 'v' },
        { '<leader>l', name = '  [L]SP' },
        { '<leader>g', name = '󰊢  [G]it' },
        { '<leader>j', name = '  [J]ust in case' },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
