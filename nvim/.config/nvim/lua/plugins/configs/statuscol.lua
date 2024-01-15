local ok, statuscol = pcall(require, 'statuscol')
local builtin = require('statuscol.builtin')

if not ok then
  return
end

statuscol.setup({
  bt_ignore = {
    'nofile',
    'prompt',
    'terminal',
  },
  ft_ignore = {
    'NvimTree',
    'terminal',
    'dashboard',
    'nvcheatsheet',
    'dapui_watches',
    'dap-repl',
    'dapui_console',
    'dapui_stacks',
    'dapui_breakpoints',
    'dapui_scopes',
    'help',
    'vim',
    'alpha',
    'dashboard',
    'neo-tree',
    'Trouble',
    'noice',
    'lazy',
    'nvdash',
    'toggleterm',
  },
  relculright = true,
  segments = {
    {
      text = { ' ' },
    },
    {
      sign = {
        name = { 'Diagnostic' },
        maxwidth = 1,
        auto = false,
      },
    },
    {
      sign = {
        name = { 'Dap' },
        maxwidth = 1,
        auto = true,
      },
    },
    {
      sign = {
        name = { 'todo' },
        maxwidth = 1,
        auto = true,
      },
    },
    {
      text = {
        builtin.lnumfunc,
        ' ',
      },
    },
    {
      sign = {
        namespace = { 'gitsign' },
        maxwidth = 1,
        auto = false,
        wrap = false,
        fillchar = ' ',
      },
    },
    {
      text = { ' ' },
      hl = 'Normal',
      condition = { true, builtin.not_empty },
    },
  },
})
