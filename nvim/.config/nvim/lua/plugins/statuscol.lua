---@type LazyPluginSpec
return {
  'luukvbaal/statuscol.nvim', -- https://github.com/luukvbaal/statuscol.nvim
  -- event = 'VeryLazy',
  branch = '0.10',
  dependencies = {
    'kevinhwang91/nvim-ufo', -- https://github.com/kevinhwang91/nvim-ufo
    dependencies = 'kevinhwang91/promise-async', -- https://github.com/kevinhwang91/promise-async
    opts = {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
    },
    init = function()
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end,
  },
  config = function()
    local builtin = require('statuscol.builtin')
    require('statuscol').setup({
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
        'Trouble',
        'noice',
        'lazy',
        'nvdash',
        'toggleterm',
      },
      relculright = true,
      segments = {
        { text = { ' ' } },
        {
          sign = {
            namespace = { 'diagnostic' },
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
            auto = false,
          },
        },
        { text = { ' ' } },
        {
          text = { builtin.foldfunc },
          click = 'v:lua.ScFa',
        },
        { text = { ' ' } },
        {
          sign = {
            namespace = { 'gitsigns' },
            maxwidth = 1,
            auto = false,
            wrap = false,
          },
        },
      },
    })
  end,
}
