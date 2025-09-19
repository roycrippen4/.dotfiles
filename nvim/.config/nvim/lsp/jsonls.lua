---@type vim.lsp.Config
return {
  cmd = { 'bun', '--bun', 'run', 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}
