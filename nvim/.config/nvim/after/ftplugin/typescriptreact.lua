-- Automatically end a self-closing tag when pressing /
vim.keymap.set('i', '/', function()
  local node = vim.treesitter.get_node()
  if not node then
    return '/'
  end

  if node:type() == 'jsx_opening_element' then
    local char_at_cursor = vim.fn.strcharpart(vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 2), 0, 1)
    local already_have_space = char_at_cursor == ' '

    return already_have_space and '/>' or ' />'
  end

  return '/'
end, { expr = true, buffer = true })

local function put_and_move()
  vim.schedule(function()
    local content = vim.fn.getreg('')
    vim.api.nvim_put({ content }, '', true, true)
    vim.api.nvim_feedkeys('bi', 'n', false)
  end)
end

-- Automatically indent between tags on <CR>
vim.keymap.set('i', '<CR>', function()
  local char_at_cursor = vim.fn.strcharpart(vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1), 0, 1)
  local prev_char = vim.fn.strcharpart(vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 2), 0, 1)
  local node = vim.treesitter.get_node()

  vim.defer_fn(function()
    log('char: ' .. char_at_cursor)
    log('prev: ' .. prev_char)
    log('node: ' .. node:type())
    log('')
  end, 0)

  if not node then
    return '<CR>'
  end

  if prev_char == '>' and char_at_cursor == '<' and node:type() == 'jsx_closing_element' then
    local keys = vim.api.nvim_replace_termcodes('<CR><Esc>O', true, true, true)
    vim.api.nvim_feedkeys(keys, 'n', false)
    return
  end

  local keys = '<Esc>ciw<CR><Esc>O'

  if node:type() == 'jsx_closing_element' and char_at_cursor == '<' then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), 'n', false)
    put_and_move()
    return
  end

  if node:type() == 'jsx_text' and prev_char == '>' then
    keys = '<Right>' .. keys
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), 'n', false)
    put_and_move()
    return
  end

  return '<CR>'
end, { expr = true, buffer = true })
