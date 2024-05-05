# Filetype spefific scripts
Example: 'after/ftplugin/lua.lua' will be sourced for 'lua' file types (specifically, every time filetype buffer option is set to 'lua'). Don't forget to use local variants of setting options (:setlocal or vim.opt_local) and creating mappings (vim.api.nvim_buf_set_keymap()).
