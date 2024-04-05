-- Runs javascript files with node
vim.keymap.set('n', '<Leader>js', function()
  local path = vim.api.nvim_buf_get_name(0)
  local filetype = string.sub(path, -2)
  if filetype == 'js' then
    vim.keymap.set('n', '<leader>js', function()
      require('plugins.local.term').send('node ' .. path, 'F')
    end, { desc = 'Run Javascript file' })
  end
end)

-- Automatically end a self-closing tag when pressing /
vim.keymap.set('i', '/', function()
  local node = vim.treesitter.get_node()
  if not node then
    return '/'
  end

  if node:type() == 'jsx_opening_element' then
    local char_after_cursor = vim.fn.strcharpart(vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1), 0, 1) ---@type string

    if char_after_cursor == '>' then
      return '/'
    end

    local char_at_cursor = vim.fn.strcharpart(vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 2), 0, 1) ---@type string
    local already_have_space = char_at_cursor == ' '

    return already_have_space and '/>' or ' />'
  end

  return '/'
end, { expr = true, buffer = true })
