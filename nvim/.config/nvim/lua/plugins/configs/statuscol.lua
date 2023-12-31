local ok, statuscol = pcall(require, 'statuscol')
local builtin = require('statuscol.builtin')

if not ok then
  return
end

statuscol.setup({
  ft_ignore = { 'NvimTree', 'terminal' },
  relculright = true,
  segments = {
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
  },
})
