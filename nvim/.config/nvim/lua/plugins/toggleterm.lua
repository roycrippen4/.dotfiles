vim.api.nvim_create_autocmd('TermOpen', { command = 'setlocal nonu nornu signcolumn=no foldcolumn=0' })

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

  if ft == 'zig' then
    vim.cmd('TermExec direction=horizontal size=16 cmd="zig run ' .. file .. '"')
    return
  end

  if ft == 'python' then
    vim.cmd('TermExec direction=horizontal size=16 cmd="python ' .. file .. '"')
    return
  end

  vim.notify('Unknown filetype detected! Supported filetypes: lua, typescript, javascript', vim.log.levels.ERROR)
end

---@type LazyPluginSpec
return {
  'akinsho/toggleterm.nvim', -- https://github.com/akinsho/toggleterm.nvim
  version = '*',
  keys = {
    {
      mode = { 'n', 't' },
      '<M-h>',
      '<cmd> ToggleTerm direction=horizontal size=16 <cr>',
    },
    {
      mode = { 'n', 't' },
      '<M-v>',
      '<cmd> ToggleTerm direction=vertical size=80 <cr>',
    },
    {
      mode = { 'n', 't' },
      '<M-f>',
      '<cmd> ToggleTerm direction=float size=80 <cr>',
    },
    {
      mode = 'n',
      '<leader>lr',
      run_current_file,
    },
  },
  config = function()
    require('toggleterm').setup()
    if vim.fn.filereadable('.nvmrc') == 1 then
      vim.cmd('TermExec direction=horizontal size=16 cmd="nvm use"')
      vim.cmd('ToggleTerm direction=horizontal')
    end
  end,
}
