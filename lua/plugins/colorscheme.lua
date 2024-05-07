-- return {
--   { -- You can easily change to a different colorscheme.
--     -- Change the name of the colorscheme plugin below, and then
--     -- change the command in the config to whatever the name of that colorscheme is.
--     --
--     -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--     'folke/tokyonight.nvim',
--     priority = 1000, -- Make sure to load this before all the other start plugins.
--     init = function()
--       -- Load the colorscheme here.
--       -- Like many other themes, this one has different styles, and you could load
--       -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--       vim.cmd.colorscheme 'tokyonight-night'
--
--       -- You can configure highlights by doing something like:
--       vim.cmd.hi 'Comment gui=none'
--     end,
--   },
-- }
return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    --'folke/tokyonight.nvim',
    -- 'rebelot/kanagawa.nvim',
    'AstroNvim/astrotheme',
    -- 'catppuccin/nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'kanagawa-wave'
      -- vim.cmd.colorscheme 'kanagawa-dragon'
      -- vim.cmd.colorscheme 'tokyonight-night'
      -- vim.cmd.colorscheme 'catppuccin-mocha'

      -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Comment gui=none'

      require('astrotheme').setup {
        palette = 'astrodark', -- String of the default palette to use when calling `:colorscheme astrotheme`
        background = {         -- :h background, palettes to use when using the core vim background colors
          light = 'astrolight',
          dark = 'astrodark',
        },

        style = {
          transparent = false,         -- Bool value, toggles transparency.
          inactive = true,             -- Bool value, toggles inactive window color.
          float = true,                -- Bool value, toggles floating windows background colors.
          neotree = true,              -- Bool value, toggles neo-trees background color.
          border = true,               -- Bool value, toggles borders.
          title_invert = true,         -- Bool value, swaps text and background colors.
          italic_comments = true,      -- Bool value, toggles italic comments.
          simple_syntax_colors = false, -- Bool value, simplifies the amounts of colors used for syntax highlighting.
        },

        termguicolors = true,    -- Bool value, toggles if termguicolors are set by AstroTheme.

        terminal_color = true,   -- Bool value, toggles if terminal_colors are set by AstroTheme.

        plugin_default = 'auto', -- Sets how all plugins will be loaded
        -- "auto": Uses lazy / packer enabled plugins to load highlights.
        -- true: Enables all plugins highlights.
        -- false: Disables all plugins.

        plugins = { -- Allows for individual plugin overrides using plugin name and value from above.
          ['bufferline.nvim'] = false,
        },
      }

      vim.cmd.colorscheme 'astrodark'
    end,
  },
}
