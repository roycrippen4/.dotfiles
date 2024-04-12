vim.keymap.set('n', '<leader>ts', function()
  require('plugins.local.term').send('bun run ' .. vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), 'F')
end, { desc = 'Run Typescript file' })
