vim.hl.priorities.semantic_tokens = 0
vim.lsp.inlay_hint.enable(true)
vim.g.zig_fmt_parse_errors = 0

---@type string | nil
vim.g.zig_test_cmd = nil

local function conditional_hover()
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
  local test_cmd = ('zig test %s --test-filter "%s"'):format(vim.fn.expand('%'), test_name)
  local cmd = ("direction=horizontal size=16 cmd='%s'"):format(test_cmd)
  vim.g.zig_test_cmd = cmd
  vim.cmd.TermExec(cmd)
end

local build = function()
  vim.cmd.TermExec('direction=horizontal size=16 cmd="zig build"')
end

local function run_file()
  vim.cmd.TermExec('direction=horizontal size=16 cmd="zig run ' .. vim.fn.expand('%') .. '"')
end

local function run_last_test()
  if not vim.g.zig_test_cmd then
    vim.notify('No previous test found')
    return
  end

  vim.cmd.TermExec(vim.g.zig_test_cmd)
end

local function run_project()
  local main_file = vim.fn.getcwd() .. '/src/main.zig'
  vim.cmd.TermExec('direction=horizontal size=16 cmd="zig run ' .. main_file .. '"')
end

vim.keymap.set('n', 'K', conditional_hover, { desc = "Conditionally runs test if it's under the cursor", buffer = true })
vim.keymap.set('n', '<leader>b', build, { desc = '[B]uild project', buffer = true })
vim.keymap.set('n', '<leader>lr', run_file, { desc = 'Run current file', buffer = true })
vim.keymap.set('n', '<leader>lt', run_last_test, { desc = 'Run last test', buffer = true })
vim.keymap.set('n', 'R', run_project, { desc = 'Run current project', buffer = true })
