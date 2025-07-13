return {
  {
    'christoomey/vim-tmux-navigator', -- Seamless TMUX splits navigation
    lazy = false,
    init = function()
      vim.g.tmux_navigator_no_mappings = 1 -- Disable C-h/C-j/C-k/C-l default mapping
    end,
  },
}
