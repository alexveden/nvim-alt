return {
    'rmagatti/auto-session',
    dependencies = { 'nvim-neo-tree/neo-tree.nvim' },
    config = function()
        -- auto-session specifics
        vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

        require('auto-session').setup {
            log_level = 'error',
            auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
            pre_save_cmds = { 'Neotree close' },
            -- post_restore_cmds = { 'Neotree filesystem show' },
        }
    end,
}
