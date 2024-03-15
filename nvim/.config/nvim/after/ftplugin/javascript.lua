vim.keymap.set('n', '<Leader>js', function()
  local path = vim.api.nvim_buf_get_name(0)
  local filetype = string.sub(path, -2)
  if filetype == 'js' then
    vim.keymap.set('n', '<leader>js', function()
      require('plugins.local.term').send('node ' .. path, 'F')
    end, { desc = 'Run Javascript file' })
  end
end)
