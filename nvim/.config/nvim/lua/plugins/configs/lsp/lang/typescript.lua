local M = require('plugins.configs.lsp.lspconfig')
local api = require('typescript-tools.api')

vim.keymap.set('n', 'fi', '<cmd> TSToolsOrganizeImports<CR>', { desc = 'Organize imports' })

return {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
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
  handlers = {
    ['textDocument/publishDiagnostics'] = api.filter_diagnostics({ 80001, 80004 }),
  },
}
