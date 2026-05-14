vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Shift down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Shift up and center' })


vim.keymap.set('n', '<leader>kd', '<CMD>Glance definitions<CR>')
vim.keymap.set('n', '<leader>kr', '<CMD>Glance references<CR>')
vim.keymap.set('n', '<leader>ky', '<CMD>Glance type_definitions<CR>')
vim.keymap.set('n', '<leader>km', '<CMD>Glance implementations<CR>')
vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
