vim.keymap.set('n', '<leader>lr', '<cmd> RustRun <cr>', { desc = '[R]un file', buffer = true })
vim.keymap.set('n', '<leader>lt', '<cmd> RustLsp! testables <cr>', { desc = '[T]est file', buffer = true })
vim.keymap.set('n', 'K', '<cmd> RustLsp hover actions <cr>', { buffer = true })
-- vim.keymap.set('n', '<leader>ld', '<cmd> RustLsp debuggables <cr>', { desc = '[D]ebug', buffer = true })
