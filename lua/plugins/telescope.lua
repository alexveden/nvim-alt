-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'debugloop/telescope-undo.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      'benfowler/telescope-luasnip.nvim',
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      local telescope_actions = require 'telescope.actions'
      local builtin = require 'telescope.builtin'

      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        defaults = {
          dynamic_preview_title = true,
          --path_display = { shorten = { len = 2 } }
          path_display = { 'smart' },
          mappings = {
            i = {
              ['<PageUp'] = false,
              ['<PageDown'] = false,
              ['<C-Up>'] = telescope_actions.cycle_history_prev,
              ['<C-Down>'] = telescope_actions.cycle_history_next,

              ['<C-PageUp>'] = telescope_actions.preview_scrolling_up,
              ['<C-PageDown>'] = telescope_actions.preview_scrolling_down,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      require('telescope').load_extension 'undo'
      require('telescope').load_extension 'luasnip'

      -- See `:help telescope.builtin`
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[H]elp' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[K]eymaps' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]iles' })
      vim.keymap.set('n', '<leader>fs', '<cmd>Telescope luasnip<CR>', { desc = '[S]nippets' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[w]ord' })
      vim.keymap.set('n', '<leader>fW', function()
        require('telescope.builtin').live_grep {
          additional_args = function(args)
            return vim.list_extend(args, { '--hidden', '--no-ignore' })
          end,
        }
      end, { desc = '[W]ord in all files' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[D]iagnostics' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[R]esume' })
      vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = '[O]ld Files' })
      vim.keymap.set('n', '<leader>ft', '<cmd>:TodoTelescope keywords=TODO,FIX,BUG,FIXME<CR>', { desc = '[T]ODOs and other' })
      vim.keymap.set('n', '<leader>fm', builtin.man_pages, { desc = '[M]an pages' })
      --vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<C-f>', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>jf', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = 'Fuzzy [F]ind' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[N]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
