---@type LazyPluginSpec
return {
  'luukvbaal/statuscol.nvim', -- https://github.com/luukvbaal/statuscol.nvim
  dependencies = 'lewis6991/gitsigns.nvim',
  opts = {
    bt_ignore = { 'nofile', 'prompt', 'terminal' },
    ft_ignore = {
      'NvimTree',
      'Trouble',
      'alpha',
      'dap-repl',
      'dapui_breakpoints',
      'dapui_console',
      'dapui_scopes',
      'dapui_stacks',
      'dapui_watches',
      'dashboard',
      'dashboard',
      'help',
      'lazy',
      'terminal',
      'toggleterm',
      'vim',
    },
    relculright = true,
  },
  config = function(_, opts)
    opts.segments = {
      { text = { ' ' } },
      { sign = { namespace = { 'diagnostic' }, maxwidth = 1, auto = false } },
      { sign = { name = { 'Dap' }, maxwidth = 1, auto = true } },
      { sign = { name = { 'todo' }, maxwidth = 1, auto = true } },
      { text = { require('statuscol.builtin').lnumfunc, auto = false } },
      { text = { ' ' } },
      { sign = { namespace = { 'gitsigns' }, maxwidth = 1, auto = false, wrap = false } },
    }

    require('statuscol').setup(opts)
  end,
}
