local utils = require('core.utils')
local M = {}

M.on_attach = function(client, bufnr)
  utils.load_mappings('lspconfig', { buffer = bufnr })
  local conf = require('nvconfig').ui.lsp

  if not conf.semantic_tokens and client.supports_method('textDocument/semantic_tokens') then
    client.server_capabilities.semanticTokensProvider = nil
  end

  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { 'markdown', 'plaintext' },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  },
}

local cwd = vim.fn.getcwd(-1, -1)
if cwd ~= nil then
  if string.sub(cwd, -4) == 'nvim' then
    require('neodev').setup()
  end
end

return M
