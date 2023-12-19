local path = vim.api.nvim_buf_get_name(0)
local filetype = string.sub(path, -2)
if filetype == 'ts' then
  vim.keymap.set('n', '<leader>ts', function()
    require('nvterm.terminal').send('bun run ' .. path, 'horizontal')
  end, { desc = 'Run Typescript file' })
end
