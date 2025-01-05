return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'python' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },

        disable = function(lang, buf)
          local max_filesize = 300 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true, disable = { 'ruby' } },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['ak'] = { query = '@block.outer', desc = 'around block' },
            ['ik'] = { query = '@block.inner', desc = 'inside block' },
            ['af'] = { query = '@function.outer', desc = 'around function ' },
            ['if'] = { query = '@function.inner', desc = 'inside function ' },
          },
        },
        move = {
          enable = true,
          set_jumps = false,
          goto_next_start = {
            [']k'] = { query = '@block.outer', desc = 'Next block start' },
            [']f'] = { query = '@function.outer', desc = 'Next function start' },
            ["]J"] = { query = "@code_cell.comment", desc = "Next code cell start" },
            ["]j"] = { query = "@cell.comment", desc = "Next cell start" },
            [']t'] = { query = '@markdown.task', desc = 'Next markdown task' },
          },
          goto_next_end = {
          },
          goto_previous_start = {
            ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
            ["[J"] = { query = "@code_cell.comment", desc = "Prev code cell start" },
            ["[j"] = { query = "@cell.comment", desc = "Prev cell start" },
            ['[t'] = { query = '@markdown.task', desc = 'Prev markdown task' },
          },
          goto_previous_end = {
          },
        },
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      vim.filetype.add {
        extension = {
          c3 = 'c3',
          c3i = 'c3',
          c3t = 'c3',
        },
      }

      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.c3 = {
        install_info = {
          url = 'https://github.com/c3lang/tree-sitter-c3',
          files = { 'src/parser.c', 'src/scanner.c' },
          branch = 'main',
        },
      }

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
