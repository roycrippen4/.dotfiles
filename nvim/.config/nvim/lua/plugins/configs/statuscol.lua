local options = {
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
        require('statuscol.builtin').lnumfunc,
        ' ',
      },
    },
    {
      sign = {
        namespace = { 'gitsign' },
        maxwidth = 1,
        auto = true,
      },
    },
  },
}

return options
