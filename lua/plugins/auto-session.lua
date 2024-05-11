return {
    'rmagatti/auto-session',
    enabled = false,
    dependencies = { 'nvim-neo-tree/neo-tree.nvim' },
    config = function()
        local git_dir = vim.fn.getcwd() .. "/.git"

        -- Only allow session saving in working dir with .git (projects)
        if vim.fn.isdirectory(git_dir) ~= 1 then
            require('auto-session').setup {
                auto_session_enabled = false,
            }
        else
            -- auto-session specifics
            vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

            require('auto-session').setup {
                auto_session_enabled = true,
                log_level = 'error',
                auto_session_suppress_dirs = { '~/', '~/code', '~/Downloads', '/', "~/cloud/" },
                pre_save_cmds = { 'Neotree close' },
                -- post_restore_cmds = { 'Neotree filesystem show' },
            }
        end
    end,
}
