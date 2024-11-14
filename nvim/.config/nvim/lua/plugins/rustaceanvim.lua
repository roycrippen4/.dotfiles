---@module 'rustaceanvim'
---@type LazyPluginSpec
return {
  'mrcjkb/rustaceanvim', -- https://github.com/mrcjkb/rustaceanvim
  version = '^5',
  ft = { 'rust' },
  ---@type rustaceanvim.Opts
  opts = {
    server = {
      default_settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = { enable = true },
          },
        },
        checkOnSave = true,
        procMacro = {
          enable = true,
          ignored = {
            ['async-trait'] = { 'async_trait' },
            ['napi-derive'] = { 'napi' },
            ['async-recursion'] = { 'async_recursion' },
          },
        },
      },
    },
    tools = {
      float_win_config = { border = 'rounded' },
      executor = 'toggleterm',
    },
  },
  config = function(_, opts)
    U.set_lsp_mappings({
      -- stylua: ignore start
      { '<leader>lc', '<cmd> RustLsp openCargo    <cr>', desc = "[L]SP Open Cargo" },
      { '<leader>lC', '<cmd> RustLsp flyCheck     <cr>', desc = "[L]SP Run FlyCheck" },
      { '<leader>lD', '<cmd> RustLsp debuggables  <cr>', desc = "[L]SP Debug Rust" },
      { '<leader>lE', '<cmd> RustLsp externalDocs <cr>', desc = "[L]SP Open External Docs" },
      { '<leader>le', '<cmd> RustLsp explainError <cr>', desc = "[L]SP Explain Error" },
      -- stylua: ignore end
    })
    vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
  end,
}
