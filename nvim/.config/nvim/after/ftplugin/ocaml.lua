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

  vim.cmd("TermExec direction=horizontal size=16 cmd='dune build && dune exec " .. ocaml_proj .. "'")
end

local function run_file()
  local file = vim.fn.expand('%')
  vim.cmd.TermExec("direction=horizontal size=16 cmd='ocaml " .. file .. "'")
end

vim.keymap.set('n', 'R', run_project, { desc = '[R]un project' })
vim.keymap.set('n', '<leader>b', '<cmd> TermExec direction=horizontal size=16 cmd="dune build" open=0 <cr>', { desc = 'Build project' })
vim.keymap.set('n', '<leader>lt', '<cmd> TermExec direction=horizontal size=16 cmd="dune runtest" <cr>', { desc = '[T]est project' })
vim.keymap.set('n', '<leader>lr', run_file, { desc = '[R]un file' })
