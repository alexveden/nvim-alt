return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    -- enabled=false,
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
      -- helper function to parse output
      local function parse_output(proc)
        local result = proc:wait()
        local ret = {}
        if result.code == 0 then
          for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
            -- Remove trailing slash
            line = line:gsub('/$', '')
            ret[line] = true
          end
        end
        return ret
      end

      -- build git status cache
      local function new_git_status()
        return setmetatable({}, {
          __index = function(self, key)
            local ignore_proc = vim.system({ 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }, {
              cwd = key,
              text = true,
            })
            local tracked_proc = vim.system({ 'git', 'ls-tree', 'HEAD', '--name-only' }, {
              cwd = key,
              text = true,
            })
            local ret = {
              ignored = parse_output(ignore_proc),
              tracked = parse_output(tracked_proc),
            }

            rawset(self, key, ret)
            return ret
          end,
        })
      end
      local git_status = new_git_status()

      -- Clear git status cache on refresh
      local refresh = require('oil.actions').refresh
      local orig_refresh = refresh.callback
      refresh.callback = function(...)
        git_status = new_git_status()
        orig_refresh(...)
      end

      --------------------------------------------------------------------

      require('oil').setup {
        -- oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        -- set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
        default_file_explorer = true,
        -- id is automatically added at the beginning, and name at the end
        -- see :help oil-columns
        columns = {
          'icon',
          -- 'permissions',
          -- 'size',
          -- 'mtime',
        },
        -- buffer-local options to use for oil buffers
        buf_options = {
          buflisted = false,
          bufhidden = 'hide',
        },
        -- window-local options to use for oil buffers
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = 'nvic',
        },
        -- send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = false,
        -- skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
        skip_confirm_for_simple_edits = false,
        -- selecting a new/moved/renamed file or directory will prompt you to save changes first
        -- (:help prompt_save_on_select_new_entry)
        prompt_save_on_select_new_entry = true,
        -- oil will automatically delete hidden buffers after this delay
        -- you can set the delay to false to disable cleanup entirely
        -- note that the cleanup process only starts when none of the oil buffers are currently displayed
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
          -- enable or disable lsp file operations
          enabled = true,
          -- time to wait for lsp file operations to complete before skipping
          timeout_ms = 1000,
          -- set to true to autosave buffers that are updated with lsp willrenamefiles
          -- set to "unmodified" to only save unmodified buffers
          autosave_changes = false,
        },
        -- constrain the cursor to the editable parts of the oil buffer
        -- set to `false` to disable, or "name" to keep it on the file names
        constrain_cursor = 'editable',
        -- set to true to watch the filesystem for changes and reload oil
        watch_for_changes = false,
        -- keymaps in oil buffer. can be any value that `vim.keymap.set` accepts or a table of keymap
        -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
        -- additionally, if it is a string that matches "actions.<name>",
        -- it will use the mapping at require("oil.actions").<name>
        -- set to `false` to remove a keymap
        -- see :help oil-actions for a list of all available actions
        keymaps = {
          ['g?'] = { 'actions.show_help', mode = 'n' },
          ['<left>'] = { 'actions.parent', mode = 'n' },
          ['<Backspace>'] = { 'actions.parent', mode = 'n' },
          ['<right>'] = { 'actions.select', mode = 'n', opts = { close = true } },
          ['<cr>'] = 'actions.select',
          ['<C-s>'] = { 'actions.select', opts = { vertical = true, close = true } },
          -- ['<c-h>'] = { 'actions.select', opts = { horizontal = true, close = true } },
          ['<C-p>'] = 'actions.preview',
          ['<C-d>'] = 'actions.preview_scroll_down',
          ['<C-u>'] = 'actions.preview_scroll_up',
          ['<C-q>'] = 'actions.send_to_qflist',
          ['h'] = 'actions.toggle_hidden',
          ['<C-y>'] = 'actions.yank_entry',
          ['<esc>'] = { 'actions.close', mode = 'n' },
          ['<c-l>'] = 'actions.refresh',
          ['.'] = { 'actions.open_cwd', mode = 'n' },
          ['-'] = { 'actions.open_cwd', mode = 'n' },
          ['gs'] = { 'actions.change_sort', mode = 'n' },
          ['gx'] = 'actions.open_external',
          ['gh'] = { 'actions.toggle_hidden', mode = 'n' },
          ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
          ['gd'] = {
            desc = 'Toggle file detail view',
            callback = function()
              detail = not detail
              if detail then
                require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
              else
                require('oil').set_columns { 'icon' }
              end
            end,
          },
        },
        -- set to false to disable all of the above keymaps
        use_default_keymaps = true,
        view_options = {
          -- show files and directories that start with "."
          show_hidden = false,
          -- this function defines what is considered a "hidden" file
          -- is_hidden_file = function(name, bufnr)
          --   local m = name:match '^%.'
          --   return m ~= nil
          -- end,
          is_hidden_file = function(name, bufnr)
            local dir = require('oil').get_current_dir(bufnr)
            local is_dotfile = vim.startswith(name, '.') and name ~= '..'
            -- if no local directory (e.g. for ssh connections), just hide dotfiles
            if not dir then
              return is_dotfile
            end
            -- dotfiles are considered hidden unless tracked
            if is_dotfile then
              return true
              -- NOTE: possible to keep it if it's git tracked
              -- return not git_status[dir].tracked[name]
            else
              -- Check if file is gitignored
              return git_status[dir].ignored[name]
            end
          end,

          -- this function defines what will never be shown, even when `show_hidden` is set
          is_always_hidden = function(name, bufnr)
            return false
          end,
          -- sort file names with numbers in a more intuitive order for humans.
          -- can be "fast", true, or false. "fast" will turn it off for large directories.
          natural_order = 'fast',
          -- sort file and directory names case insensitive
          case_insensitive = false,
          sort = {
            -- sort order can be "asc" or "desc"
            -- see :help oil-columns to see which columns are sortable
            { 'type', 'asc' },
            { 'name', 'asc' },
          },
          -- customize the highlight group for the file name
          highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
            return nil
          end,
        },
        -- extra arguments to pass to scp when moving/copying files over ssh
        extra_scp_args = {},
        -- experimental support for performing file operations with git
        git = {
          -- return true to automatically git add/mv/rm files
          add = function(path)
            return false
          end,
          mv = function(src_path, dest_path)
            return false
          end,
          rm = function(path)
            return false
          end,
        },
        -- configuration for the floating window in oil.open_float
        float = {
          -- padding around the floating window
          padding = 3,
          -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          max_width = 0,
          max_height = 0,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
          -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
          get_win_title = nil,
          -- preview_split: split direction: "auto", "left", "right", "above", "below".
          preview_split = 'auto',
          -- this is the config that will be passed to nvim_open_win.
          -- change values here to customize the layout
          override = function(conf)
            return conf
          end,
        },
        -- configuration for the file preview window
        preview_win = {
          -- whether the preview window is automatically updated when the cursor is moved
          update_on_cursor_moved = true,
          -- how to open the preview window "load"|"scratch"|"fast_scratch"
          preview_method = 'fast_scratch',
          -- a function that returns true to disable preview on a file e.g. to avoid lag
          disable_preview = function(filename)
            return false
          end,
          -- window-local options to use for preview window buffers
          win_options = {},
        },
        -- configuration for the floating action confirmation window
        confirmation = {
          -- width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_width and max_width can be a single value or a list of mixed integer/float types.
          -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
          max_width = 0.9,
          -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
          min_width = { 40, 0.4 },
          -- optionally define an integer/float for the exact width of the preview window
          width = nil,
          -- height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_height and max_height can be a single value or a list of mixed integer/float types.
          -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
          max_height = 0.9,
          -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
          min_height = { 5, 0.1 },
          -- optionally define an integer/float for the exact height of the preview window
          height = nil,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
        },
        -- configuration for the floating progress window
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = 'rounded',
          minimized_border = 'none',
          win_options = {
            winblend = 0,
          },
        },
        -- configuration for the floating ssh window
        ssh = {
          border = 'rounded',
        },
        -- configuration for the floating keymaps help window
        keymaps_help = {
          border = 'rounded',
        },
      }
    end,
  },
}
