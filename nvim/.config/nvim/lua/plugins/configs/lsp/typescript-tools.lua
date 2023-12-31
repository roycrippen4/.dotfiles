local M = require('plugins.configs.lsp.lspconfig')
local api = require('typescript-tools.api')

vim.keymap.set('n', 'fi', '<cmd> TSToolsOrganizeImports<CR>', { desc = 'Organize imports' })

local options = {

  on_attach = M.on_attach,
  settings = {
    tsserver_plugins = {
      '@styled/typescript-styled-plugin',
    },
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
    ['textDocument/publishDiagnostics'] = api.filter_diagnostics({ 80001 }),
  },
}

return options
