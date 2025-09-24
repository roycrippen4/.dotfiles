---@diagnostic disable: missing-fields - Neotest complains loudly

---@module 'rustaceanvim'
---@type LazyPluginSpec
return {
  'mrcjkb/rustaceanvim', -- https://github.com/mrcjkb/rustaceanvim
  version = '^6',
  lazy = false,
  dependencies = {
    {
      'nvim-neotest/neotest',
      dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-treesitter/nvim-treesitter',
      },
      keys = {
        { '<leader>ns', '<cmd> Neotest summary <cr>', { desc = 'Toggle Neotest Summary' } },
        { '<leader>no', '<cmd> Neotest output-panel <cr>', { desc = 'Toggle Neotest Output Panel' } },
      },
    },
  },
  config = function()
    ---@type rustaceanvim.Opts
    vim.g.rustaceanvim = {
      server = {
        on_attach = require('lsp').on_attach,
        default_settings = {
          ['rust-analyzer'] = {
            completion = { fullFunctionSignatures = { enable = true } },
            inlayHints = { renderColons = false },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },
            procMacro = {
              enable = true,
              ignored = {
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
          },
        },
      },
      tools = { float_win_config = { border = 'rounded' } },
    }

    require('neotest').setup({
      adapters = { require('rustaceanvim.neotest') },
      output_panel = { open = 'vsplit | vertical resize 100' },
      status = { virtual_text = true },
      quickfix = { enabled = false },
    })
  end,
}
