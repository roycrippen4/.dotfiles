local function provider_selector()
  return { 'treesitter', 'indent' }
end
local function open_all_folds()
  require('ufo').openAllFolds()
end
local function close_all_folds()
  require('ufo').closeAllFolds()
end

---@type LazyPluginSpec
return {
  'luukvbaal/statuscol.nvim', -- https://github.com/luukvbaal/statuscol.nvim
  branch = '0.10',
  dependencies = {
    'kevinhwang91/nvim-ufo', -- https://github.com/kevinhwang91/nvim-ufo
    dependencies = 'kevinhwang91/promise-async', -- https://github.com/kevinhwang91/promise-async
    opts = { provider_selector = provider_selector },
    keys = { { 'zR', open_all_folds }, { 'zM', close_all_folds } },
  },
  config = function()
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
        'noice',
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
        { text = { require('statuscol.builtin').lnumfunc, auto = false } },
        { text = { ' ' } },
        -- { text = { require('statuscol.builtin').foldfunc }, click = 'v:lua.ScFa' },
        -- { text = { ' ' } },
        { sign = { namespace = { 'gitsigns' }, maxwidth = 1, auto = false, wrap = false } },
      },
    })
  end,
}
