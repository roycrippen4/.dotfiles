local find_node_ancestor = require('utils').find_node_ancestor
local ocaml_proj = nil

local function run_project()
  if not ocaml_proj then
    local cwd_content = vim.split(vim.fn.glob(vim.fn.getcwd() .. '/*'), '\n', { trimempty = true })
    ---@type string
    local project_abs_filepath = vim.iter(cwd_content):find(function(path)
      if path:match('%.opam') then
        return true
      end
    end)
    ocaml_proj = vim.split(vim.fn.fnamemodify(project_abs_filepath, ':t'), '.opam')[1]
  end

  vim.cmd("TermExec direction=vertical size=80 cmd='dune build && dune exec " .. ocaml_proj .. "'")
end

local function run_file()
  local file = vim.fn.expand('%')
  vim.cmd.TermExec("direction=horizontal size=16 cmd='ocaml " .. file .. "'")
end

local function allow_unused_rec()
  local buf = vim.fn.bufnr()

  local node = find_node_ancestor({ 'value_definition', 'let_expression' }, vim.treesitter.get_node())
  if not node then
    return
  end

  local text = vim.treesitter.get_node_text(node, 0)
  local first_line = text:gmatch('(.-)\n')()
  local warnings = first_line:match('%[@warning%s*"(.-)"%s*%]')

  if not warnings or warnings == {} then
    local start_row, start_col = node:start()
    vim.api.nvim_buf_set_text(buf, start_row, start_col + 3, start_row, start_col + 3, { '[@warning "-39"]' })
    return
  end

  if warnings:find('-39', 1, true) then
    return
  end

  local start_row, start_col = node:start()
  vim.api.nvim_buf_set_text(buf, start_row, start_col + 14, start_row, start_col + 14, { '-39' })
end

local function allow_unused_var()
  local buf = vim.fn.bufnr()

  local node = find_node_ancestor({ 'value_definition', 'let_expression' }, vim.treesitter.get_node())
  if not node then
    return
  end

  local text = vim.treesitter.get_node_text(node, 0)
  local first_line = text:gmatch('(.-)\n')()
  local warnings = first_line:match('%[@warning%s*"(.-)"%s*%]')

  if not warnings or warnings == {} then
    local start_row, start_col = node:start()
    vim.api.nvim_buf_set_text(buf, start_row, start_col + 3, start_row, start_col + 3, { '[@warning "-26-27"]' })
    return
  end

  if warnings:find('-26-27', 1, true) then
    return
  end

  local start_row, start_col = node:start()
  vim.api.nvim_buf_set_text(buf, start_row, start_col + 14, start_row, start_col + 14, { '-26-27' })
end

vim.keymap.set('n', 'R', run_project, { desc = '[R]un project' })
vim.keymap.set('n', '<leader>b', '<cmd> TermExec direction=horizontal size=16 cmd="dune build" open=0 <cr>', { desc = 'Build project' })
vim.keymap.set('n', '<leader>lt', '<cmd> TermExec direction=horizontal size=16 cmd="dune runtest" <cr>', { desc = '[T]est project' })
vim.keymap.set('n', '<leader>lr', run_file, { desc = '[R]un file' })
vim.keymap.set('n', '<leader>ur', allow_unused_rec, { desc = 'Allow unused rec' })
vim.keymap.set('n', '<leader>uv', allow_unused_var, { desc = 'Allow unused var' })
