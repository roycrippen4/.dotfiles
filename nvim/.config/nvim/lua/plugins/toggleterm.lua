---@module "toggleterm"
---@type LazyPluginSpec
return {
  'akinsho/toggleterm.nvim', -- https://github.com/akinsho/toggleterm.nvim
  version = '*',
  cmd = { 'ToggleTerm', 'TermExec' },
  keys = {
    { mode = { 'n', 't' }, '<M-h>', '<cmd> ToggleTerm direction=horizontal size=16 <cr>' },
    { mode = { 'n', 't' }, '<M-v>', '<cmd> ToggleTerm direction=vertical size=80 <cr>' },
    { mode = { 'n', 't' }, '<M-f>', '<cmd> ToggleTerm direction=float size=80 <cr>' },
  },
  opts = {
    ---@param term Terminal
    on_open = function(term)
      vim.cmd.startinsert()
      vim.cmd.setlocal('nonu nornu signcolumn=no foldcolumn=0')
      if term:is_float() then
        require('utils').create_backdrop({ buf = term.bufnr })
      end
    end,
    highlights = { NormalFloat = { bg = require('onedark.colors').black_darker } },
    float_opts = { border = 'none' },
  },
}
