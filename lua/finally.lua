--- Finalization script
---

-- Folded text highlighting
vim.cmd('hi Folded guifg=#ffffff guibg=Normal')

-- Installing basic text objectss + key bindings!
require('text_objects').map_text_objects()
