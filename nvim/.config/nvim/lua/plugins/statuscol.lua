---@type LazyPluginSpec
return {
  'luukvbaal/statuscol.nvim', -- https://github.com/luukvbaal/statuscol.nvim
  config = function()
    local builtin = require('statuscol.builtin')

    require('statuscol').setup({
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
      segments = {
        { text = { ' ' } },
        { sign = { namespace = { 'diagnostic' }, maxwidth = 1, auto = false } },
        { sign = { name = { 'Dap' }, maxwidth = 1, auto = true } },
        { sign = { name = { 'todo' }, maxwidth = 1, auto = true } },
        { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        { text = { ' ' } },
        { text = { builtin.lnumfunc, auto = false } },
        { text = { ' ' } },
        { sign = { namespace = { 'gitsigns' }, maxwidth = 1, auto = false, wrap = false } },
      },
    })
  end,
}
