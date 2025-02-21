---@module 'rustaceanvim'
---@type LazyPluginSpec
return {
  'mrcjkb/rustaceanvim', -- https://github.com/mrcjkb/rustaceanvim
  version = '^5',
  lazy = false,
  keys = {
    {
      '<leader>lt',
      function()
        vim.cmd.RustLsp({ 'testables', bang = true })
      end,
      desc = '[L]sp Rerun Last Test',
    },
  },
  config = function()
    ---@type rustaceanvim.Opts
    vim.g.rustaceanvim = {
      server = {
        on_attach = require('lsp').on_attach,
        default_settings = {
          ['rust-analyzer'] = {
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
  end,
}
