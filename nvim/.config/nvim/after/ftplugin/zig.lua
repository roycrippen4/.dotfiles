vim.highlight.priorities.semantic_tokens = 0
vim.lsp.inlay_hint.enable(true)

vim.keymap.set('n', '<leader>b', function()
  vim.cmd('TermExec direction=horizontal size=16 cmd="zig build"')
end)

vim.keymap.set('n', 'K', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local str_content = vim.treesitter.get_node({ pos = { pos[1] - 1, pos[2] } })

  if not str_content or str_content:type() ~= 'string_content' then
    vim.lsp.buf.hover()
    return
  end

  local str = str_content:parent()
  if not str or str:type() ~= 'string' then
    vim.lsp.buf.hover()
    return
  end

  local test_declaration = str:parent()
  if not test_declaration or test_declaration:type() ~= 'test_declaration' then
    vim.lsp.buf.hover()
    return
  end

  local test_name = vim.treesitter.get_node_text(str_content, 0)
  local file = vim.fn.expand('%')

  local test_cmd = ('zig test %s --test-filter "%s"'):format(file, test_name)
  local cmd = string.format("TermExec direction=horizontal size=16 cmd='%s'", test_cmd)
  vim.cmd(cmd)
end)
