local cwd = vim.fn.getcwd()
local ocaml_proj = nil

local function run_current_file()
  local ft = vim.bo.ft

  if ft ~= 'ocaml' then
    return
  end

  if not ocaml_proj then
    local cwd_content = vim.split(vim.fn.glob(cwd .. '/*'), '\n', { trimempty = true })

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

vim.keymap.set({ 'n', 'i' }, '<C-s>', '<cmd> w <cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>lr', run_current_file, { desc = 'Run current file' })
