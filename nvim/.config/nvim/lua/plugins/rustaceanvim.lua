---@module 'rustaceanvim'
---@type LazyPluginSpec
return {
  'mrcjkb/rustaceanvim', -- https://github.com/mrcjkb/rustaceanvim
  version = '^5',
  lazy = false,
  ft = 'rust',
  config = function()
    ---@type rustaceanvim.Opts
    vim.g.rustaceanvim = {
      server = {
        on_attach = require('core.utils').on_attach,
        default_settings = {
          ['rust-analyzer'] = {
            inlayHints = { renderColons = false },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
            },
            procMacro = {
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
          },
        },
      },
      tools = {
        float_win_config = { border = 'rounded' },
        on_initialized = function()
          vim.lsp.codelens.refresh()
          vim.lsp.inlay_hint.enable(true)
        end,
      },
    }

    require('which-key').add({
      {
        '<leader>lt',
        function()
          vim.cmd.RustLsp({ 'testables', bang = true })
        end,
        desc = '[L]sp Rerun Last Test',
      },
    })
  end,
}
