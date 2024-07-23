return {
  'pmizio/typescript-tools.nvim', -- https://github.com/pmizio/typescript-tools.nvim
  ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'svelte' },
  dependencies = {
    'nvim-lua/plenary.nvim', -- https://github.com/nvim-lua/plenary.nvim
    'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
  },
  opts = {
    on_attach = require('plugins.lsp.lsp-utils').on_attach,
    capabilities = require('plugins.lsp.lsp-utils').capabilities,
    settings = {
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
        jsxAttributeCompletionStyle = 'auto',
      },
    },
  },
  config = function(_, opts)
    local config = vim.tbl_deep_extend(
      'error',
      opts,
      { handlers = { ['textDocument/publishDiagnostics'] = require('typescript-tools.api').filter_diagnostics({ 80001, 80004 }) } }
    )
    require('typescript-tools').setup(config)
  end,
}
