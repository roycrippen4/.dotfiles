---@type LazyPluginSpec
return {
  'mrcjkb/rustaceanvim', -- https://github.com/mrcjkb/rustaceanvim
  version = '^5',
  ft = { 'rust' },
  config = function()
    require('core.utils').set_lsp_mappings({
      -- stylua: ignore start
      { '<leader>lc', '<cmd> RustLsp openCargo    <cr>', desc = "[L]SP Open Cargo" },
      { '<leader>lC', '<cmd> RustLsp flyCheck     <cr>', desc = "[L]SP Run FlyCheck" },
      { '<leader>lD', '<cmd> RustLsp debuggables  <cr>', desc = "[L]SP Debug Rust" },
      { '<leader>lE', '<cmd> RustLsp externalDocs <cr>', desc = "[L]SP Open External Docs" },
      { '<leader>le', '<cmd> RustLsp explainError <cr>', desc = "[L]SP Explain Error" },
      { '<leader>lr', '<cmd> RustRun              <cr>', desc = "[L]SP Run File" },
      -- stylua: ignore end
    })

    ---@module 'rustaceanvim'
    ---@type rustaceanvim.Opts
    vim.g.rustaceanvim = {
      server = {
        on_attach = require('plugins.lsp.lsp-utils').on_attach,
      },
      tools = { float_win_config = { border = 'rounded' } },
    }
  end,
}
