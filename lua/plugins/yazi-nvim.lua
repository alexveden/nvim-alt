return {
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      -- check the installation instructions at
      -- https://github.com/folke/snacks.nvim
      "folke/snacks.nvim"
    },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      -- {
      --   "-",
      --   mode = { "n", "v" },
      --   "<cmd>Yazi<cr>",
      --   desc = "Open yazi at the current file",
      -- },
      {
        "-",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,
      -- customize the keymaps that are active when yazi is open and focused. The
      -- defaults are listed below. Note that the keymaps simply hijack input and
      -- they are never sent to yazi, so only try to map keys that are never
      -- needed by yazi.
      --
      -- Also:
      -- - use e.g. `open_file_in_tab = false` to disable a keymap
      -- - you can customize only some of the keymaps (not all of them)
      -- - you can opt out of all keymaps by setting `keymaps = false`
      keymaps = {
        show_help = "<f1>",
        open_file_in_vertical_split = "<c-s>",
        -- open_file_in_horizontal_split = "<c-x>",
        -- open_file_in_tab = "<c-t>",
        grep_in_directory = false,
        -- replace_in_directory = "<c-g>",
        cycle_open_buffers = "<tab>",
        copy_relative_path_to_selected_files = "<c-y>",
        send_to_quickfix_list = "<c-q>",
        change_working_directory = "<c-\\>",
        open_and_pick_window = "<c-o>",
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  }
}
