
local toggle_qf = function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
      break
    end
  end

  if qf_exists == true then
    vim.cmd "cclose"
  else
    vim.cmd "copen"
  end
end

vim.keymap.set({ 'n', 'v' }, '<leader>q', toggle_qf, { desc = '[Q]ickfix window' })
vim.keymap.set({ 'n'}, ']q', "<cmd>cnext<cr>", { desc = '[Q]ickfix ] next' })
vim.keymap.set({ 'n'}, '[q', "<cmd>cprev<cr>", { desc = '[Q]ickfix [ prev' })

return {
  'kevinhwang91/nvim-bqf',
  filetype = 'qf',
}
