vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.fn.filereadable('.nvmrc') == 1 then
      vim.cmd('TermExec direction=horizontal size=16 cmd="nvm use" open=0')
    end
  end,
})

local function test_current_file()
  local ft = vim.bo.ft
  local file = vim.fn.expand('%')

  if ft == 'zig' then
    vim.cmd.TermExec('direction=float size=80 cmd="zig test ' .. file .. '"')
    return
  end

  if ft == 'rust' then
    vim.cmd.RustLsp({ 'testables', bang = true })
    return
  end

  if ft == 'lua' then
    vim.cmd.TermExec('direction=vertical size=80 cmd="./scripts/test"')
    return
  end

  if ft == 'ocaml' then
    vim.cmd.TermExec('direction=horizontal size=16 cmd="dune runtest"')
    return
  end

  vim.notify('Unknown filetype detected! Supported filetypes: zig, rust, lua, ocaml', vim.log.levels.ERROR)
end

local function run_current_file()
  local ft = vim.bo.ft
  local file = vim.fn.expand('%')

  if ft == 'lua' then
    vim.cmd('source')
    return
  end

  if ft == 'typescript' or ft == 'javascript' then
    vim.cmd('TermExec direction=horizontal size=16 cmd="bun run ' .. file .. '"')
    return
  end

  if ft == 'rust' then
    vim.cmd('RustRun')
    return
  end

  if ft == 'python' then
    vim.cmd('TermExec direction=horizontal size=16 cmd="python ' .. file .. '"')
    return
  end

  if ft == 'ocaml' then
    vim.cmd.TermExec("direction=horizontal size=16 cmd='ocaml " .. file .. "'")
    return
  end

  if ft == 'sh' then
    local absolute_path = vim.api.nvim_buf_get_name(0)
    if string.find(vim.api.nvim_exec2('!file ' .. file, { output = true }).output, 'executable', 0, true) then
      vim.cmd('TermExec direction=horizontal size=16 cmd="' .. absolute_path .. '"')
    else
      vim.ui.select(
        { 'yes', 'no' },
        { prompt = 'Make file executable?' },
        ---@param choice 'yes'|'no'
        function(choice)
          if choice == 'yes' then
            vim.fn.system('chmod +x ' .. file)
            vim.cmd('TermExec direction=horizontal size=16 cmd="bash ' .. file .. '"')
          else
            vim.notify('File is not executable.', vim.log.levels.INFO)
          end
        end
      )
    end
    return
  end

  vim.notify('Unknown filetype detected! Supported filetypes: lua, typescript, javascript', vim.log.levels.ERROR)
end

---@type LazyPluginSpec
return {
  'akinsho/toggleterm.nvim', -- https://github.com/akinsho/toggleterm.nvim
  version = '*',
  cmd = { 'ToggleTerm', 'TermExec' },
  keys = {
    { mode = { 'n', 't' }, '<M-h>', '<cmd> ToggleTerm direction=horizontal size=16 <cr>' },
    { mode = { 'n', 't' }, '<M-v>', '<cmd> ToggleTerm direction=vertical size=80 <cr>' },
    { mode = { 'n', 't' }, '<M-f>', '<cmd> ToggleTerm direction=float size=80 <cr>' },
    { mode = 'n', '<leader>lr', run_current_file },
    { mode = 'n', '<leader>lt', test_current_file },
  },
  opts = {
    ---@param term Terminal
    on_open = function(term)
      vim.cmd('startinsert')
      vim.cmd('setlocal nonu nornu signcolumn=no foldcolumn=0')
      if term:is_float() then
        require('utils').create_backdrop({ buf = term.bufnr })
      end
    end,
    highlights = { NormalFloat = { bg = require('colors').black_darker } },
    float_opts = { border = 'none' },
  },
}
