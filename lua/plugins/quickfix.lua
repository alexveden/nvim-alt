local toggle_qf = function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win['quickfix'] == 1 then
      qf_exists = true
      break
    end
  end

  if qf_exists == true then
    vim.cmd 'cclose'
  else
    vim.cmd 'copen'
  end
end

vim.keymap.set({ 'n', 'v' }, '<leader>q', toggle_qf, { desc = '[q]ickfix window' })
vim.keymap.set({ 'n' }, ']q', '<cmd>cnext<cr>', { desc = 'Next [q]ickfix' })
vim.keymap.set({ 'n' }, '[q', '<cmd>cprev<cr>', { desc = 'Previous [q]ickfix' })

return {
  { 'kevinhwang91/nvim-bqf', enabled=false, filetype = 'qf' },
}
